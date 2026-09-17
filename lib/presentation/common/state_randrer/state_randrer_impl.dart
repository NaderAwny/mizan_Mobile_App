// // ignore_for_file: type_literal_in_constant_pattern
// import 'package:flutter/material.dart';
// import 'package:mvvmclean/app/constants.dart';
// import 'package:mvvmclean/presentation/common/state_rendrer/state_randrer.dart';
// import 'package:mvvmclean/presentation/resources/strings_manger.dart';

// abstract class FlowState {
//   StateRendererType getStateRendererType();
//   String getMessage();
// }
// //loading state(popup or full screen)

// class LoadingState implements FlowState {
//   final StateRendererType stateRendererType;
//   String? message;
//   bool isShown = false;
//   LoadingState({
//     required this.stateRendererType,
//     this.message = AppStrings.loading,
//   });
//   @override
//   String getMessage() => message ?? AppStrings.loading;

//   @override
//   StateRendererType getStateRendererType() => stateRendererType;
// }

// //error state(popup or full screen)
// class ErrorState extends FlowState {
//   final StateRendererType stateRendererType;
//   final String message;
//   bool isShown = false;
//   ErrorState(this.stateRendererType, this.message);
//   @override
//   String getMessage() => message;

//   @override
//   StateRendererType getStateRendererType() => stateRendererType;
// }

// //content state
// class ContentState extends FlowState {
//   ContentState();
//   @override
//   String getMessage() => Constants.empty;

//   @override
//   StateRendererType getStateRendererType() =>
//       StateRendererType.contentScreenState;
// }

// //empty state(full screen)
// class EmptyState extends FlowState {
//   final String message;
//   EmptyState(this.message);
//   @override
//   String getMessage() => message;

//   @override
//   StateRendererType getStateRendererType() =>
//       StateRendererType.fullScreenEmptyState;
// }

// extension FlowStateExtension on FlowState {
//   // ignore: body_might_complete_normally_nullable
//   Widget? getScreenWidget(
//     BuildContext context,
//     Widget contentWidget,
//     Function retryActionFunction,
//   ) {
//     switch (runtimeType) {
//       case LoadingState:
//         {
//           var loadingState = this as LoadingState;
//           if (getStateRendererType() == StateRendererType.popupLoadingState) {
//             //popup loading state
//             if (!loadingState.isShown) {
//               dismissDialog(context);
//               showPopup(context, getStateRendererType(), getMessage());
//               loadingState.isShown = true;
//             }

//             //content screen state
//             return contentWidget;
//           } else {
//             return StateRandrer(
//               stateRendererType: getStateRendererType(),
//               message: getMessage(),
//               retryAction: retryActionFunction,
//             );
//           }
//         }
//       //error state
//       case ErrorState:
//         {
//           var errorState = this as ErrorState;
//           if (getStateRendererType() == StateRendererType.popupErrorStatete) {
//             //popup loading state
//             if (!errorState.isShown) {
//               dismissDialog(context);
//               showPopup(context, getStateRendererType(), getMessage());
//               errorState.isShown = true;
//             }

//             //content screen state
//             return contentWidget;
//           } else {
//             dismissDialog(context);
//             return StateRandrer(
//               stateRendererType: getStateRendererType(),
//               message: getMessage(),
//               retryAction: retryActionFunction,
//             );
//           }
//         }
//       case ContentState:
//         {
//           dismissDialog(context);
//           return contentWidget;
//         }
//       case EmptyState:
//         {
//           return StateRandrer(
//             retryAction: () {},
//             stateRendererType: getStateRendererType(),
//             message: getMessage(),
//           );
//         }
//       default:
//         {
//           dismissDialog(context);
//           return contentWidget;
//         }
//     }
//   }

//   // ignore: strict_top_level_inference
//   _isCurrentDialogShowing(BuildContext context) =>
//       ModalRoute.of(context)?.isCurrent != true;
//   // ignore: strict_top_level_inference
//   dismissDialog(BuildContext context) {
//     if (_isCurrentDialogShowing(context)) {
//       Navigator.of(context, rootNavigator: true).pop(true);
//     }
//   }

//   // ignore: strict_top_level_inference
//   showPopup(
//     BuildContext context,
//     StateRendererType stateRandererType,
//     String messge,
//   ) {
//     WidgetsBinding.instance.addPostFrameCallback(
//       (_) => showDialog(
//         context: context,
//         builder: (context) => StateRandrer(
//           message: messge,
//           retryAction: () {},
//           stateRendererType: stateRandererType,
//         ),
//       ),
//     );
//   }
// }
// ignore_for_file: type_literal_in_constant_pattern
// import 'package:flutter/material.dart';
// import 'package:mvvmclean/app/constants.dart';
// import 'package:mvvmclean/presentation/common/state_rendrer/state_randrer.dart';
// import 'package:mvvmclean/presentation/resources/strings_manger.dart';

// abstract class FlowState {
//   StateRendererType getStateRendererType();
//   String getMessage();
// }

// // loading state (POPUP or FULL SCREEN)
// class LoadingState implements FlowState {
//   final StateRendererType stateRendererType;
//   final String message;
//   bool isShown = false;

//   LoadingState({
//     required this.stateRendererType,
//     this.message = AppStrings.loading,
//   });

//   @override
//   String getMessage() => message;

//   @override
//   StateRendererType getStateRendererType() => stateRendererType;
// }

// // success state (POPUP)
// class SuccessState implements FlowState {
//   final StateRendererType stateRendererType;
//   final String message;

//   SuccessState({
//     required this.stateRendererType,
//     this.message = AppStrings.success,
//   });

//   @override
//   String getMessage() => message;

//   @override
//   StateRendererType getStateRendererType() => stateRendererType;
// }

// // error state (POPUP or FULL SCREEN)
// class ErrorState implements FlowState {
//   final StateRendererType stateRendererType;
//   final String message;
//   bool isShown = false;

//   ErrorState(this.stateRendererType, this.message);

//   @override
//   String getMessage() => message;

//   @override
//   StateRendererType getStateRendererType() => stateRendererType;
// }

// // content state
// class ContentState implements FlowState {
//   ContentState();

//   @override
//   String getMessage() => Constants.empty;

//   @override
//   StateRendererType getStateRendererType() => StateRendererType.contentState;
// }

// // empty state (FULL SCREEN)
// class EmptyState implements FlowState {
//   final String message;
//   EmptyState(this.message);

//   @override
//   String getMessage() => message;

//   @override
//   StateRendererType getStateRendererType() =>
//       StateRendererType.fullScreenEmptyState;
// }

// extension FlowStateExtension on FlowState {
//   Widget getScreenWidget(
//     BuildContext context,
//     Widget contentWidget,
//     Function retryActionFunction,
//   ) {
//     switch (runtimeType) {
//       case LoadingState:
//         dismissDialog(context);
//         if (getStateRendererType() == StateRendererType.popupLoadingState) {
//           showPopup(context, getStateRendererType(), getMessage());
//           return contentWidget;
//         } else {
//           return StateRenderer(
//             stateRendererType: getStateRendererType(),
//             message: getMessage(),
//             retryActionFunction: retryActionFunction,
//           );
//         }

//       case ErrorState:

//       case ContentState:
//         dismissDialog(context);
//         return contentWidget;

//       case EmptyState:
//         return StateRenderer(
//           stateRendererType: getStateRendererType(),
//           message: getMessage(),
//           retryActionFunction: () {},
//         );

//       case SuccessState:
//         dismissDialog(context);
//         if (getStateRendererType() == StateRendererType.popupSuccessState) {
//           showPopup(
//             context,
//             getStateRendererType(),
//             getMessage(),
//             onDismissed: () => retryActionFunction(),
//           );
//           return contentWidget;
//         } else {
//           return StateRenderer(
//             stateRendererType: getStateRendererType(),
//             message: getMessage(),
//             retryActionFunction: () {},
//           );
//         }

//       default:
//         dismissDialog(context);
//         return contentWidget;
//     }
//   }

//   // ignore: strict_top_level_inference
//   _isCurrentDialogShowing(BuildContext context) =>
//       ModalRoute.of(context)?.isCurrent != true;
//   // ignore: strict_top_level_inference
//   dismissDialog(BuildContext context) {
//     if (_isCurrentDialogShowing(context)) {
//       Navigator.of(context, rootNavigator: true).pop(true);
//     }
//   }

//   void showPopup(
//     BuildContext context,
//     StateRendererType stateRendererType,
//     String message, {
//     VoidCallback? onDismissed,
//   }) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => StateRenderer(
//           stateRendererType: stateRendererType,
//           message: message,
//           retryActionFunction: () {},
//         ),
//       );
//     });
//   }
// }
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/resources/constants_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';

abstract class FlowState {
  StateRendererType getStateRendererType();
  String getMessage();
}
//loading state(popup or full screen)

class LoadingState implements FlowState {
  final StateRendererType stateRendererType;
  String? message;
  String? title;
  bool isShown = false;
  LoadingState({
    required this.stateRendererType,
    this.message = AppStrings.loading,
    this.title,
  });
  @override
  String getMessage() => message ?? AppStrings.loading;
  String getTitle() => title ?? "";

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

//error state(popup or full screen)
class ErrorState extends FlowState {
  final StateRendererType stateRendererType;
  final String message;
  final String? title;
  bool isShown = false;
  ErrorState(
    this.stateRendererType,
    this.message, {
    this.title,
  });
  @override
  String getMessage() => message;
  String getTitle() => title ?? "";

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

//success state(popup or full screen)
class SuccessState extends FlowState {
  final StateRendererType stateRendererType;
  final String message;
  final String? title;
  bool isShown = false;
  SuccessState(
    this.stateRendererType,
    this.message, {
    this.title,
  });
  @override
  String getMessage() => message;
  String getTitle() => title ?? AppStrings.success;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

//content state
class ContentState extends FlowState {
  ContentState();
  bool isShown = false;
  @override
  String getMessage() => AppConstants.empty;

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.contentScreenState;
}

//empty state(full screen)
class EmptyState extends FlowState {
  final String message;
  EmptyState(this.message);
  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.fullScreenEmptyState;
}

extension FlowStateExtension on FlowState {
  // ignore: body_might_complete_normally_nullable
  Widget? getScreenWidget(
    BuildContext context,
    Widget contentWidget,
    Function retryActionFunction,
  ) {
    switch (runtimeType) {
      case LoadingState:
        {
          var loadingState = this as LoadingState;
          if (getStateRendererType() == StateRendererType.popupLoadingState) {
            //popup loading state
            if (!loadingState.isShown) {
              dismissDialog(context);
              showPopup(
                context,
                getStateRendererType(),
                getMessage(),
                title: loadingState.getTitle(),
              );
              loadingState.isShown = true;
            }

            //content screen state
            return contentWidget;
          } else {
            return StateRandrer(
              stateRendererType: getStateRendererType(),
              message: getMessage(),
              title: loadingState.getTitle(),
              retryAction: retryActionFunction,
            );
          }
        }
      //success state
      case SuccessState:
        {
          var successState = this as SuccessState;
          if (getStateRendererType() == StateRendererType.successScreenState) {
            //popup success state
            if (!successState.isShown) {
              dismissDialog(context);
              showPopup(
                context,
                getStateRendererType(),
                getMessage(),
                title: successState.getTitle(),
              );
              successState.isShown = true;
            }

            //content screen state
            return contentWidget;
          } else {
            return StateRandrer(
              stateRendererType: getStateRendererType(),
              message: getMessage(),
              title: successState.getTitle(),
              retryAction: retryActionFunction,
            );
          }
        }

      //error state
      case ErrorState:
        {
          var errorState = this as ErrorState;
          if (getStateRendererType() == StateRendererType.popupErrorStatete) {
            //popup error state
            if (!errorState.isShown) {
              dismissDialog(context);
              showPopup(
                context,
                getStateRendererType(),
                getMessage(),
                title: errorState.getTitle(),
              );
              errorState.isShown = true;
            }

            //content screen state
            return contentWidget;
          } else {
            dismissDialog(context);
            return StateRandrer(
              stateRendererType: getStateRendererType(),
              message: getMessage(),
              title: errorState.getTitle(),
              retryAction: retryActionFunction,
            );
          }
        }
      case ContentState:
        {
          var contentState = this as ContentState;
          if (!contentState.isShown) {
            dismissDialog(context);
            contentState.isShown = true;
          }
          return contentWidget;
        }
      case EmptyState:
        {
          return StateRandrer(
            retryAction: () {},
            stateRendererType: getStateRendererType(),
            message: getMessage(),
          );
        }
      default:
        {
          dismissDialog(context);
          return contentWidget;
        }
    }
  }

  // ignore: strict_top_level_inference
  bool _isCurrentDialogShowing(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;

  // ignore: strict_top_level_inference
  void dismissDialog(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isCurrentDialogShowing(context) &&
          Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop(true);
        developer.log("dialog dismissed");
      }
    });
  }

  // ignore: strict_top_level_inference
  void showPopup(
    BuildContext context,
    StateRendererType stateRandererType,
    String message, {
    String title = AppConstants.empty,
  }) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => StateRandrer(
          message: message,
          title: title,
          retryAction: () {},
          stateRendererType: stateRandererType,
        ),
      ),
    );
  }
}
