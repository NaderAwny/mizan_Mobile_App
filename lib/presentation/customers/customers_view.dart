// ─────────────────────────────────────────────────────────────
// CustomersView — Mizan design system & Figma Nodes #3:206 & #2025:647 compliant
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mizan/app/di.dart';
import 'package:mizan/domain/model/contact_model.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/customers/contacts_cubit/contacts_cubit.dart';
import 'package:mizan/presentation/customers/contacts_cubit/contacts_state.dart';
import 'package:mizan/presentation/customers/widgets/alphabet_section_header.dart';
import 'package:mizan/presentation/customers/widgets/contact_card.dart';
import 'package:mizan/presentation/customers/widgets/contacts_search_bar.dart';
import 'package:mizan/presentation/customers/widgets/delete_contact_bottom_sheet.dart';
import 'package:mizan/presentation/customers/widgets/vip_contact_card.dart';
import 'package:mizan/presentation/customers/widgets/vip_filter_tabs.dart';
import 'package:mizan/presentation/customers/widgets/vip_stats_hero_card.dart';
import 'package:mizan/presentation/home.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/routes_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';

class CustomersView extends StatelessWidget {
  const CustomersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactsCubit>(
      create: (_) => getIt<ContactsCubit>()..getContacts(),
      child: const _CustomersScreen(),
    );
  }
}

class _CustomersScreen extends StatefulWidget {
  const _CustomersScreen();

  @override
  State<_CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<_CustomersScreen> {
  final ScrollController _scrollController = ScrollController();
  late final TextEditingController _searchController;
  int _selectedTabIndex = 0; // 0: الكل, 1: المميزون (VIP)

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (currentScroll >= (maxScroll * 0.8)) {
        context.read<ContactsCubit>().loadMoreContacts();
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    setState(() => _selectedTabIndex = index);
    _searchController.clear();
    final isVipOnly = index == 1;
    context.read<ContactsCubit>().getContacts(search: '', isVipOnly: isVipOnly);
  }

  void _handleBack() {
    // If search is active, clear search and show all contacts first
    if (_searchController.text.isNotEmpty) {
      _searchController.clear();
      context.read<ContactsCubit>().getContacts(search: '');
      return;
    }
    // If on VIP tab, return to 'All' contacts tab
    if (_selectedTabIndex != 0) {
      _onTabChanged(0);
      return;
    }
    // If pushed as a separate route, pop it
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }
    // If embedded in HomeView, switch back to Home dashboard (tab 0)
    const SwitchHomeTabNotification(0).dispatch(context);
  }

  void _confirmDelete(BuildContext context, Contact contact) {
    DeleteContactBottomSheet.show(
      context,
      contactName: contact.name,
      onConfirmDelete: () {
        context.read<ContactsCubit>().deleteContact(contact.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactsCubit, ContactsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              _handleBack();
            }
          },
          child: Scaffold(
            backgroundColor: ColorManager.background,
            appBar: AppBar(
              backgroundColor: ColorManager.surface,
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              leading: Padding(
                padding: EdgeInsets.all(8.r),
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorManager.surfaceVariant,
                    shape: BoxShape.circle,
                    border: Border.all(color: ColorManager.border, width: 1),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorManager.textPrimary,
                      size: 16.r,
                    ),
                    onPressed: _handleBack,
                  ),
                ),
              ),
              title: Column(
                children: [
                  Text(
                    _selectedTabIndex == 1
                        ? AppStrings.vipContacts
                        : AppStrings.contactsDirectory,
                    style: getBoldStyle(
                      color: ColorManager.textPrimary,
                      fontSize: FontSize.s16,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    _selectedTabIndex == 1
                        ? AppStrings.vipSubtitle
                        : AppStrings.contactsSubtitle,
                    style: getRegularStyle(
                      color: ColorManager.textSecondary,
                      fontSize: FontSize.s11,
                    ),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                // Pinned Search and Filter Bar (Never disappears on state changes)
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
                  child: Column(
                    children: [
                      ContactsSearchBar(
                        controller: _searchController,
                        onChanged: (query) {
                          context.read<ContactsCubit>().searchContacts(query);
                        },
                        onClear: () {
                          context.read<ContactsCubit>().getContacts(search: '');
                        },
                      ),
                      SizedBox(height: 8.h),
                      VipFilterTabs(
                        tabs: const [
                          AppStrings.allContacts,
                          AppStrings.vipContacts,
                        ],
                        selectedIndex: _selectedTabIndex,
                        onTabSelected: _onTabChanged,
                      ),
                    ],
                  ),
                ),

                // Dynamic Contacts List with Loading / Error / Content states
                Expanded(
                  child:
                      state.flowState?.getScreenWidget(
                        context,
                        _buildBody(context, state),
                        () => context.read<ContactsCubit>().getContacts(),
                      ) ??
                      _buildBody(context, state),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: ColorManager.primary,
              elevation: 4,
              shape: const CircleBorder(),
              onPressed: () async {
                await Navigator.pushNamed(context, Routes.contactFormRoute);
                if (context.mounted) {
                  _searchController.clear();
                  context.read<ContactsCubit>().getContacts(search: '');
                }
              },
              child: const Icon(
                Icons.add_rounded,
                color: ColorManager.white,
                size: 28,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ContactsState state) {
    final contacts = state.data ?? [];
    final isVipMode = _selectedTabIndex == 1;

    return RefreshIndicator(
      onRefresh: () => context.read<ContactsCubit>().getContacts(),
      color: ColorManager.primary,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          // VIP Hero Stats Banner (Figma Node #2025:647)
          if (isVipMode)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: VipStatsHeroCard(
                  totalVipCount: contacts.length,
                  totalPages: (contacts.length / 20).ceil() > 0
                      ? (contacts.length / 20).ceil()
                      : 1,
                ),
              ),
            ),

          // Contacts List
          if (contacts.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 72.r,
                        height: 72.r,
                        decoration: const BoxDecoration(
                          color: ColorManager.surfaceVariant,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            isVipMode
                                ? Icons.star_border_rounded
                                : Icons.people_outline_rounded,
                            color: ColorManager.textTertiary,
                            size: 36.r,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        isVipMode
                            ? "لا يوجد عملاء مميزون مسجلون حالياً"
                            : AppStrings.noContactsYet,
                        style: getBoldStyle(
                          color: ColorManager.textSecondary,
                          fontSize: FontSize.s15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            _buildContactsSliverList(context, contacts, isVipMode),

          // Loading more spinner at bottom
          if (state.isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child: CircularProgressIndicator(color: ColorManager.primary),
                ),
              ),
            ),

          SliverToBoxAdapter(child: SizedBox(height: 80.h)),
        ],
      ),
    );
  }

  Widget _buildContactsSliverList(
    BuildContext context,
    List<Contact> contacts,
    bool isVipMode,
  ) {
    if (isVipMode) {
      // VIP Cards List with quick actions (Node #2025:647)
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final contact = contacts[index];
            return VipContactCard(
              contact: contact,
              onTap: () => _navigateToProfile(context, contact.id),
              onCall: () {},
              onSendReminder: () {},
              onDelete: () => _confirmDelete(context, contact),
            );
          }, childCount: contacts.length),
        ),
      );
    }

    // Alphabetical Grouping for All Contacts (Node #3:206)
    final grouped = _groupByFirstLetter(contacts);
    final sortedLetters = grouped.keys.toList()..sort();

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final letter = sortedLetters[index];
          final items = grouped[letter]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AlphabetSectionHeader(letter: letter),
              ...items.map(
                (c) => ContactCard(
                  contact: c,
                  onTap: () => _navigateToProfile(context, c.id),
                  onToggleVip: () {
                    context.read<ContactsCubit>().toggleVip(c.id);
                  },
                  onDelete: () => _confirmDelete(context, c),
                ),
              ),
            ],
          );
        }, childCount: sortedLetters.length),
      ),
    );
  }

  Map<String, List<Contact>> _groupByFirstLetter(List<Contact> contacts) {
    final Map<String, List<Contact>> map = {};
    for (final contact in contacts) {
      final name = contact.name.trim();
      final letter = name.isNotEmpty ? name.substring(0, 1) : "أ";
      map.putIfAbsent(letter, () => []).add(contact);
    }
    return map;
  }

  Future<void> _navigateToProfile(
    BuildContext context,
    String contactId,
  ) async {
    await Navigator.pushNamed(
      context,
      Routes.contactProfileRoute,
      arguments: contactId,
    );
    if (context.mounted) {
      _searchController.clear();
      context.read<ContactsCubit>().getContacts(search: '');
    }
  }
}
