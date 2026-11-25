import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizan/app/di.dart';
import 'package:mizan/domain/model/assistant_model.dart';
import 'package:mizan/presentation/assistant/assistant_chat_cubit/assistant_chat_cubit.dart';
import 'package:mizan/presentation/assistant/assistant_chat_cubit/assistant_chat_state.dart';
import 'package:mizan/presentation/assistant/assistant_voice_cubit/assistant_voice_cubit.dart';
import 'package:mizan/presentation/assistant/assistant_voice_cubit/assistant_voice_state.dart';
import 'package:mizan/presentation/assistant/ux/assistant_ui_signals.dart';
import 'package:mizan/presentation/assistant/ux/orb_reactive.dart';
import 'package:mizan/presentation/assistant/ux/sound_level_normalizer.dart';
import 'package:mizan/presentation/assistant/ux/suggestions.dart';
import 'package:mizan/presentation/assistant/view/widgets/assistant_message_card.dart';
import 'package:mizan/presentation/assistant/view/widgets/assistant_orb.dart';
import 'package:mizan/presentation/assistant/view/widgets/thinking_counter_widget.dart';
import 'package:mizan/presentation/assistant/view/widgets/user_bubble.dart';
import 'package:mizan/presentation/assistant/view/widgets/voice_recording_panel.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// AssistantChatView — "يا ميزان" AI Assistant Chat Screen
/// Integrates the living reactive Orb, count-up numbers, dynamic suggestions,
/// thinking counter, and voice interaction.
/// ─────────────────────────────────────────────────────────────────────────────
class AssistantChatView extends StatelessWidget {
  const AssistantChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<AssistantChatCubit>(
          create: (_) => getIt<AssistantChatCubit>()..ensureSession(),
        ),
        BlocProvider<AssistantVoiceCubit>(
          create: (_) => getIt<AssistantVoiceCubit>(),
        ),
      ],
      child: const _AssistantChatScreen(),
    );
  }
}

class _AssistantChatScreen extends StatefulWidget {
  const _AssistantChatScreen();

  @override
  State<_AssistantChatScreen> createState() => _AssistantChatScreenState();
}

class _AssistantChatScreenState extends State<_AssistantChatScreen> {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;
  late final ScrollController _scrollController;
  late final AssistantUiSignals _signals;
  late final SoundLevelNormalizer _soundNormalizer;
  final Set<String> _animatedMessageIds = <String>{};

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _focusNode = FocusNode();
    _scrollController = ScrollController();
    _signals = AssistantUiSignals();
    _soundNormalizer = SoundLevelNormalizer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AssistantVoiceCubit>().preWarm();
      }
    });
  }

  @override
  void dispose() {
    _signals.dispose();
    _textController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: <BlocListener<dynamic, dynamic>>[
        BlocListener<AssistantVoiceCubit, AssistantVoiceState>(
          listener: (BuildContext context, AssistantVoiceState voiceState) {
            voiceState.when(
              idle: () {
                _signals.soundLevel.value = 0.0;
                _signals.countdown.value = 0.0;
                final AssistantChatState chatState = context
                    .read<AssistantChatCubit>()
                    .state;
                if (chatState.flowState is LoadingState) {
                  _signals.voiceState.value = VoiceUiState.thinking;
                } else {
                  _signals.voiceState.value = VoiceUiState.idle;
                }
              },
              requestingPermission: () {
                _signals.voiceState.value = VoiceUiState.listening;
              },
              permissionDenied: (_) {
                _signals.voiceState.value = VoiceUiState.error;
              },
              greeting: () {
                _signals.voiceState.value = VoiceUiState.speaking;
              },
              listening: (String _, double rawLevel) {
                _signals.voiceState.value = VoiceUiState.listening;
                _signals.soundLevel.value = _soundNormalizer.normalize(
                  rawLevel,
                  DateTime.now(),
                );
              },
              reviewing: (String _, double autoSendCountdown) {
                _signals.voiceState.value = VoiceUiState.editing;
                _signals.countdown.value = (autoSendCountdown / 1.5).clamp(
                  0.0,
                  1.0,
                );
              },
              readyToSend: (String text) {
                _signals.voiceState.value = VoiceUiState.thinking;
                if (text.trim().isNotEmpty) {
                  context.read<AssistantChatCubit>().sendText(text.trim());
                  _scrollToBottom();
                }
              },
              error: (_, _) {
                _signals.voiceState.value = VoiceUiState.error;
              },
            );
          },
        ),
        BlocListener<AssistantChatCubit, AssistantChatState>(
          listener: (BuildContext context, AssistantChatState chatState) {
            if (chatState.flowState is LoadingState) {
              _signals.voiceState.value = VoiceUiState.thinking;
            } else if (chatState.flowState is ErrorState) {
              _signals.voiceState.value = VoiceUiState.error;
            } else {
              final AssistantVoiceState voiceState = context
                  .read<AssistantVoiceCubit>()
                  .state;
              final bool isVoiceActive = voiceState.maybeWhen(
                greeting: () => true,
                listening: (_, _) => true,
                reviewing: (_, _) => true,
                orElse: () => false,
              );
              if (!isVoiceActive) {
                _signals.voiceState.value = VoiceUiState.idle;
              }
            }
            _scrollToBottom();
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: ColorManager.background,
        appBar: _buildAppBar(context),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              // Top trust badge
              _buildTrustNotice(),

              // Messages / Content Body
              Expanded(
                child: BlocBuilder<AssistantChatCubit, AssistantChatState>(
                  builder:
                      (BuildContext context, AssistantChatState chatState) {
                        if (chatState.messages.isEmpty) {
                          return _buildEmptyWelcomeState(chatState);
                        }
                        return _buildChatMessagesList(chatState);
                      },
                ),
              ),

              // Voice Panel Overlay (if recording or reviewing)
              BlocBuilder<AssistantVoiceCubit, AssistantVoiceState>(
                builder:
                    (BuildContext context, AssistantVoiceState voiceState) {
                      return VoiceRecordingPanel(
                        state: voiceState,
                        onCancel: () {
                          context.read<AssistantVoiceCubit>().cancelListening();
                        },
                        onSend: (String text) {
                          context.read<AssistantVoiceCubit>().cancelListening();
                          context.read<AssistantChatCubit>().sendText(text);
                          _scrollToBottom();
                        },
                        onAppend: () {
                          context.read<AssistantVoiceCubit>().appendSpeech();
                        },
                        onReRecord: () {
                          context.read<AssistantVoiceCubit>().reRecord();
                        },
                        onTextEdited: (String newText) {
                          context
                              .read<AssistantVoiceCubit>()
                              .updateReviewText(newText);
                        },
                      );
                    },
              ),

              // Bottom Input Bar
              _buildBottomBar(context),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: ColorManager.background,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: ColorManager.textPrimary,
          size: 20,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            AppStrings.assistantTitle,
            style: getBoldStyle(
              color: ColorManager.textPrimary,
              fontSize: FontSize.s16,
            ),
          ),
          SizedBox(height: 2.h),
          ValueListenableBuilder<VoiceUiState>(
            valueListenable: _signals.voiceState,
            builder: (BuildContext context, VoiceUiState vs, Widget? child) {
              return Text(
                vs.arabicLabel,
                style: getRegularStyle(
                  color: vs == VoiceUiState.error
                      ? ColorManager.error
                      : ColorManager.textSecondary,
                  fontSize: FontSize.s11,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTrustNotice() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r20.r),
        border: Border.all(color: ColorManager.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.shield_outlined,
            size: 14.r,
            color: ColorManager.secondary,
          ),
          SizedBox(width: 6.w),
          Text(
            "مفيش عملية بتتسجّل من غير تأكيدك",
            style: getMediumStyle(
              color: ColorManager.textSecondary,
              fontSize: FontSize.s11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWelcomeState(AssistantChatState chatState) {
    final bool isThinking = chatState.flowState is LoadingState;

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 12.h),

            // Feature 1: Living reactive Orb
            GestureDetector(
              onTap: () {
                context.read<AssistantVoiceCubit>().onMicTap();
              },
              child: OrbReactive(
                signals: _signals,
                orb: AssistantOrb(
                  size: OrbSize.large,
                  state: isThinking ? OrbState.thinking : OrbState.idle,
                  heroTag: 'assistant_orb',
                  diameter: 176.r,
                ),
                ringColor: const Color(0xFFD1A153),
                size: 200.r,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              AppStrings.assistantTitle,
              style: getBoldStyle(
                color: ColorManager.textPrimary,
                fontSize: FontSize.s22,
              ),
            ),
            SizedBox(height: 6.h),
            ValueListenableBuilder<VoiceUiState>(
              valueListenable: _signals.voiceState,
              builder: (BuildContext context, VoiceUiState vs, Widget? child) {
                return Text(
                  vs == VoiceUiState.idle
                      ? "مساعدك الذكي في حسابات المحل"
                      : vs.arabicLabel,
                  style: getRegularStyle(
                    color: ColorManager.textSecondary,
                    fontSize: FontSize.s13,
                  ),
                );
              },
            ),
            SizedBox(height: 20.h),

            // Thinking ticker if loading on empty state
            if (isThinking) ...<Widget>[
              ThinkingCounterWidget(
                onTimeoutRetry: () {
                  context.read<AssistantChatCubit>().retryLast();
                },
              ),
            ] else ...<Widget>[_buildQuickSuggestions()],
          ],
        ),
      ),
    );
  }

  Widget _buildChatMessagesList(AssistantChatState chatState) {
    final bool isThinking = chatState.flowState is LoadingState;

    // Find the last assistant message index and last user text for dynamic suggestions
    int lastAssistantIndex = -1;
    String? lastUserText;
    for (int i = chatState.messages.length - 1; i >= 0; i--) {
      final ChatMessage m = chatState.messages[i];
      if (lastAssistantIndex == -1 && m.sender == ChatSender.assistant) {
        lastAssistantIndex = i;
      }
      if (lastUserText == null && m.sender == ChatSender.user) {
        lastUserText = m.text;
      }
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: chatState.messages.length + (isThinking ? 1 : 0),
      itemBuilder: (BuildContext context, int index) {
        if (index == chatState.messages.length && isThinking) {
          return ThinkingCounterWidget(
            onTimeoutRetry: () {
              context.read<AssistantChatCubit>().retryLast();
            },
          );
        }

        final ChatMessage msg = chatState.messages[index];

        if (msg.sender == ChatSender.user) {
          return UserBubble(
            message: msg,
            onRetry: () {
              context.read<AssistantChatCubit>().retryLast();
            },
          );
        } else {
          return AssistantMessageCard(
            message: msg,
            isActionExpired: chatState.isActionExpired,
            isExecutingAction: chatState.isExecutingAction,
            isLastMessage: index == lastAssistantIndex,
            lastUserText: lastUserText,
            isAnimated: _animatedMessageIds.contains(msg.id),
            onAnimated: () => _animatedMessageIds.add(msg.id),
            onConfirm: () {
              context.read<AssistantChatCubit>().confirm();
            },
            onCancel: () {
              context.read<AssistantChatCubit>().cancel();
            },
            onOptionSelected: (String option) {
              _textController.text = option;
              context.read<AssistantChatCubit>().sendText(option);
              _scrollToBottom();
            },
            onSuggestionTap: (Suggestion s) {
              if (s.sendText != null) {
                context.read<AssistantChatCubit>().sendText(s.sendText!);
                _scrollToBottom();
              } else if (s.route != null) {
                Navigator.of(context).pushNamed(s.route!);
              }
            },
          );
        }
      },
    );
  }

  Widget _buildQuickSuggestions() {
    final List<String> suggestions = <String>[
      "مين عليه فلوس متأخرة؟",
      "مبيعات النهارده كام؟",
      "مشتريات الشهر كام؟",
      "إجمالي الديون كام؟",
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8.w,
        runSpacing: 8.h,
        children: suggestions.map((String text) {
          return ActionChip(
            label: Text(
              text,
              style: getMediumStyle(
                color: ColorManager.textPrimary,
                fontSize: FontSize.s12,
              ),
            ),
            backgroundColor: ColorManager.surface,
            elevation: 0,
            side: const BorderSide(color: ColorManager.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.r20.r),
            ),
            onPressed: () {
              context.read<AssistantChatCubit>().sendText(text);
              _textController.clear();
              _scrollToBottom();
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: const BoxDecoration(
        color: ColorManager.surface,
        border: Border(top: BorderSide(color: ColorManager.border)),
      ),
      child: Row(
        children: <Widget>[
          // Mic Button
          BlocBuilder<AssistantVoiceCubit, AssistantVoiceState>(
            builder: (BuildContext context, AssistantVoiceState voiceState) {
              final bool isListening = voiceState.maybeWhen(
                listening: (String? _, double? _) => true,
                orElse: () => false,
              );
              final bool isGreeting = voiceState.maybeWhen(
                greeting: () => true,
                orElse: () => false,
              );
              final bool isActive = isListening || isGreeting;

              return IconButton(
                onPressed: () {
                  context.read<AssistantVoiceCubit>().onMicTap();
                },
                icon: CircleAvatar(
                  backgroundColor: isActive
                      ? ColorManager.successContainer
                      : ColorManager.lightPrimary,
                  radius: 20.r,
                  child: SvgPicture.asset(
                    IconAssets.mic,
                    width: 20.r,
                    height: 20.r,
                    colorFilter: ColorFilter.mode(
                      isActive ? ColorManager.success : ColorManager.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(width: 8.w),

          // Text Field
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: ColorManager.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.r24.r),
              ),
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                textInputAction: TextInputAction.send,
                decoration: const InputDecoration(
                  hintText: "اضغط وتكلم أو اكتب سؤالك...",
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
                onSubmitted: (String value) {
                  final String text = value.trim();
                  if (text.isNotEmpty) {
                    context.read<AssistantChatCubit>().sendText(text);
                    _textController.clear();
                    _scrollToBottom();
                  }
                },
              ),
            ),
          ),
          SizedBox(width: 8.w),

          // Send Button
          IconButton(
            onPressed: () {
              final String text = _textController.text.trim();
              if (text.isNotEmpty) {
                context.read<AssistantChatCubit>().sendText(text);
                _textController.clear();
                _scrollToBottom();
              }
            },
            icon: CircleAvatar(
              backgroundColor: ColorManager.primary,
              radius: 18.r,
              child: const Icon(
                Icons.arrow_upward_rounded,
                color: ColorManager.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
