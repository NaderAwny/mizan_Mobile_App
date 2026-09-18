import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/domain/model/contact_model.dart';
import 'package:mizan/domain/use_case/delete_contact_use_case.dart';
import 'package:mizan/domain/use_case/get_contacts_use_case.dart';
import 'package:mizan/domain/use_case/get_vip_contacts_use_case.dart';
import 'package:mizan/domain/use_case/toggle_vip_contact_use_case.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/customers/contacts_cubit/contacts_state.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';

@injectable
class ContactsCubit extends Cubit<ContactsState> {
  final GetContactsUseCase _getContactsUseCase;
  final GetVipContactsUseCase _getVipContactsUseCase;
  final ToggleVipContactUseCase _toggleVipContactUseCase;
  final DeleteContactUseCase _deleteContactUseCase;

  ContactsCubit(
    this._getContactsUseCase,
    this._getVipContactsUseCase,
    this._toggleVipContactUseCase,
    this._deleteContactUseCase,
  ) : super(const ContactsState());

  int currentPage = 1;
  final int pageSize = 20;
  Timer? _debounceTimer;

  Future<void> getContacts({String? search, bool? isVipOnly}) async {
    currentPage = 1;
    final bool vipFilter = isVipOnly ?? state.isVipOnly;
    final String query = search ?? state.searchQuery;

    final isInitialLoad = state.data == null && query.isEmpty;

    if (isInitialLoad) {
      emit(state.copyWith(
        flowState: LoadingState(
          stateRendererType: StateRendererType.fullScreenLoadingState,
          title: AppStrings.loading,
          message: "جاري جلب قائمة العملاء...",
        ),
        isVipOnly: vipFilter,
        searchQuery: query,
        hasMore: true,
      ));
    } else {
      emit(state.copyWith(
        isVipOnly: vipFilter,
        searchQuery: query,
        hasMore: true,
      ));
    }

    final result = vipFilter
        ? await _getVipContactsUseCase.execute(
            GetVipContactsInput(page: currentPage, pageSize: pageSize),
          )
        : await _getContactsUseCase.execute(
            GetContactsInput(
              page: currentPage,
              pageSize: pageSize,
              search: query.isEmpty ? null : query,
            ),
          );

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(state.copyWith(
          flowState: ErrorState(
            StateRendererType.fullScreenErrorState,
            failure.message,
            title: "تعذر تحميل العملاء",
          ),
        ));
      },
      (page) {
        if (isClosed) return;
        emit(state.copyWith(
          data: page.items,
          flowState: page.items.isEmpty
              ? EmptyState(AppStrings.noContactsYet)
              : ContentState(),
          hasMore: currentPage < page.totalPages,
        ));
      },
    );
  }

  Future<void> loadMoreContacts() async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));
    final int nextPage = currentPage + 1;

    final result = state.isVipOnly
        ? await _getVipContactsUseCase.execute(
            GetVipContactsInput(page: nextPage, pageSize: pageSize),
          )
        : await _getContactsUseCase.execute(
            GetContactsInput(
              page: nextPage,
              pageSize: pageSize,
              search: state.searchQuery.isEmpty ? null : state.searchQuery,
            ),
          );

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(state.copyWith(isLoadingMore: false));
      },
      (page) {
        if (isClosed) return;
        currentPage = nextPage;
        final currentItems = state.data ?? [];
        final updatedItems = [...currentItems, ...page.items];
        emit(state.copyWith(
          data: updatedItems,
          isLoadingMore: false,
          hasMore: currentPage < page.totalPages,
        ));
      },
    );
  }

  void searchContacts(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      getContacts(search: query);
    });
  }

  void setVipFilter(bool isVipOnly) {
    if (state.isVipOnly == isVipOnly) return;
    getContacts(isVipOnly: isVipOnly);
  }

  Future<void> toggleVip(String contactId) async {
    final currentList = state.data;
    if (currentList == null || currentList.isEmpty) return;

    final index = currentList.indexWhere((c) => c.id == contactId);
    if (index == -1) return;

    final originalContact = currentList[index];
    final updatedContact = Contact(
      id: originalContact.id,
      name: originalContact.name,
      phoneNumber: originalContact.phoneNumber,
      notes: originalContact.notes,
      isVip: !originalContact.isVip,
      contactEmail: originalContact.contactEmail,
      createdAt: originalContact.createdAt,
      updatedAt: originalContact.updatedAt,
    );

    final optimisticList = List<Contact>.from(currentList);
    optimisticList[index] = updatedContact;
    emit(state.copyWith(data: optimisticList));

    final result = await _toggleVipContactUseCase.execute(contactId);

    result.fold(
      (failure) {
        if (isClosed) return;
        // Revert to original
        final revertedList = List<Contact>.from(state.data ?? optimisticList);
        final revIndex = revertedList.indexWhere((c) => c.id == contactId);
        if (revIndex != -1) {
          revertedList[revIndex] = originalContact;
        }
        emit(state.copyWith(
          data: revertedList,
          flowState: ErrorState(
            StateRendererType.popupErrorStatete,
            failure.message,
            title: "فشل تحديث حالة التمييز",
          ),
        ));
      },
      (serverContact) {
        if (isClosed) return;
        final confirmedList = List<Contact>.from(state.data ?? optimisticList);
        final confirmedIndex = confirmedList.indexWhere((c) => c.id == contactId);
        if (confirmedIndex != -1) {
          confirmedList[confirmedIndex] = serverContact;
        }
        emit(state.copyWith(data: confirmedList));
      },
    );
  }

  Future<bool> deleteContact(String contactId) async {
    emit(state.copyWith(
      flowState: LoadingState(
        stateRendererType: StateRendererType.popupLoadingState,
        title: "جاري الحذف",
        message: "جاري حذف الطرف...",
      ),
    ));

    final result = await _deleteContactUseCase.execute(contactId);

    return result.fold(
      (failure) {
        if (isClosed) return false;
        emit(state.copyWith(
          flowState: ErrorState(
            StateRendererType.popupErrorStatete,
            failure.message,
            title: "فشل الحذف",
          ),
        ));
        return false;
      },
      (_) {
        if (isClosed) return true;
        final updatedList = (state.data ?? [])
            .where((c) => c.id != contactId)
            .toList();
        emit(state.copyWith(
          data: updatedList,
          flowState: updatedList.isEmpty
              ? EmptyState(AppStrings.noContactsYet)
              : ContentState(),
        ));
        return true;
      },
    );
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
