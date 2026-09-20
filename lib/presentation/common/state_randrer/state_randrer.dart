// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:mvvmclean/presentation/resources/assets_manger.dart';
// import 'package:mvvmclean/presentation/resources/color_manger.dart';
// import 'package:mvvmclean/presentation/resources/strings_manger.dart';
// import 'package:mvvmclean/presentation/resources/styles_mangers.dart';
// import 'package:mvvmclean/presentation/resources/value_manger.dart';

// enum StateRendererType {
//   // popup  states(Dialog)
//   popupLoadingState,
//   popupErrorStatete,
//   //full screen states(full screen)
//   fullScreenLoadingState,
//   fullScreenErrorState,
//   fullScreenEmptyState,
//   //General state
//   contentScreenState,
// }

// // ignore: must_be_immutable
// class StateRandrer extends StatelessWidget {
//   StateRendererType stateRendererType;
//   String message;
//   String title;
//   Function retryAction;

//   StateRandrer({
//     super.key,
//     required this.stateRendererType,
//     this.message = AppStrings.loading,
//     this.title = "",
//     required this.retryAction,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return _getStateWidget(context);
//   }

//   // ignore: unused_element
//   Widget _getStateWidget(BuildContext context) {
//     switch (stateRendererType) {
//       case StateRendererType.popupLoadingState:
//         return _getPopupDialog(context, [
//           _getAnimatedImage(JsonAssets.loading),
//         ]);

//       case StateRendererType.popupErrorStatete:
//         return _getPopupDialog(context, [
//           _getAnimatedImage(JsonAssets.error),
//           _getMessage(message),
//           _getRetryButton(AppStrings.ok, context),
//         ]);

//       case StateRendererType.fullScreenLoadingState:
//         return _getItemsColumn([
//           _getAnimatedImage(JsonAssets.loading),
//           _getMessage(message),
//         ]);

//       case StateRendererType.fullScreenErrorState:
//         return _getItemsColumn([
//           _getAnimatedImage(JsonAssets.error),
//           _getMessage(message),
//           _getRetryButton(AppStrings.tryAgain, context),
//         ]);
//       case StateRendererType.fullScreenEmptyState:
//         return _getItemsColumn([
//           _getAnimatedImage(JsonAssets.empty),
//           _getMessage(message),
//         ]);
//       case StateRendererType.contentScreenState:
//         return Container();
//       // ignore: unreachable_switch_default
//       default:
//         return Container();
//     }
//   }

//   // popup dialog
//   Widget _getPopupDialog(BuildContext context, List<Widget> children) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(AppSize.s14),
//       ),
//       elevation: AppSize.s1,
//       backgroundColor: Colors.transparent,
//       child: Container(
//         decoration: BoxDecoration(
//           color: ColorManger.white,
//           shape: BoxShape.rectangle,
//           borderRadius: BorderRadius.circular(AppSize.s14),
//           boxShadow: const [BoxShadow(color: Colors.black26)],
//         ),
//         child: _getDialogContent(context, children),
//       ),
//     );
//   }

//   Widget _getDialogContent(BuildContext context, List<Widget> children) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: children,
//     );
//   }

//   // ignore: unused_element
//   Widget _getItemsColumn(List<Widget> children) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: children,
//     );
//   }

//   Widget _getAnimatedImage(String animationPath) {
//     return SizedBox(
//       width: AppSize.s100,
//       height: AppSize.s100,
//       child: Lottie.asset(animationPath),
//     );
//   }

//   Widget _getMessage(String message) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(AppPadding.p8),
//         child: Text(
//           message,
//           style: getRegularStyle(
//             color: ColorManger.black,
//             fontSize: AppSize.s18,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _getRetryButton(String buttonText, BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(AppPadding.p18),
//         child: SizedBox(
//           width: double.infinity,
//           child: ElevatedButton(
//             onPressed: () {
//               if (stateRendererType == StateRendererType.fullScreenErrorState) {
//                 retryAction.call();
//               } else {
//                 //popup error state
//                 Navigator.of(context).pop();
//               }
//             },

//             child: Text(buttonText),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:mvvmclean/presentation/resources/assets_manger.dart';
// import 'package:mvvmclean/presentation/resources/color_manger.dart';
// import 'package:mvvmclean/presentation/resources/font_manger.dart';
// import 'package:mvvmclean/presentation/resources/strings_manger.dart';
// import 'package:mvvmclean/presentation/resources/styles_mangers.dart';
// import 'package:mvvmclean/presentation/resources/value_manger.dart';

// enum StateRendererType {
//   // POPUP STATES (DIALOG)
//   popupLoadingState,
//   popupErrorState,
//   popupSuccessState,

//   // FULL SCREEN STATES (FULL SCREEN)
//   fullScreenLoadingState,
//   fullScreenErrorState,
//   fullScreenEmptyState,

//   // general
//   contentState,
// }

// // ignore: must_be_immutable
// class StateRenderer extends StatelessWidget {
//   StateRendererType stateRendererType;
//   String message;
//   String title;
//   Function retryActionFunction;

//   // ignore: use_key_in_widget_constructors
//   StateRenderer({
//     required this.stateRendererType,
//     this.message = AppStrings.loading,
//     this.title = "",
//     required this.retryActionFunction,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return _getStateWidget(context);
//   }

//   Widget _getStateWidget(BuildContext context) {
//     switch (stateRendererType) {
//       case StateRendererType.popupLoadingState:
//         return _getPopUpDialog(context, [
//           _getAnimatedImage(JsonAssets.loading),
//         ]);
//       case StateRendererType.popupSuccessState:
//         return _getPopUpDialog(context, [
//           _getAnimatedImage(JsonAssets.success),
//           _getMessage(message),
//         ]);
//       case StateRendererType.popupErrorState:
//         return _getPopUpDialog(context, [
//           _getAnimatedImage(JsonAssets.error),
//           _getMessage(message),
//           _getRetryButton(AppStrings.ok, context),
//         ]);
//       case StateRendererType.fullScreenLoadingState:
//         return _getItemsColumn([
//           _getAnimatedImage(JsonAssets.loading),
//           _getMessage(message),
//         ]);
//       case StateRendererType.fullScreenErrorState:
//         return _getItemsColumn([
//           _getAnimatedImage(JsonAssets.error),
//           _getMessage(message),
//           _getRetryButton(AppStrings.tryAgain, context),
//         ]);
//       case StateRendererType.fullScreenEmptyState:
//         return _getItemsColumn([
//           _getAnimatedImage(JsonAssets.empty),
//           _getMessage(message),
//         ]);
//       case StateRendererType.contentState:
//         return Container();
//       // ignore: unreachable_switch_default
//       default:
//         return Container();
//     }
//   }

//   Widget _getPopUpDialog(BuildContext context, List<Widget> children) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(AppSize.s14),
//       ),
//       elevation: AppSize.s1,
//       backgroundColor: Colors.transparent,
//       child: Container(
//         decoration: BoxDecoration(
//           color: ColorManger.white,
//           shape: BoxShape.rectangle,
//           borderRadius: BorderRadius.circular(AppSize.s14),
//           boxShadow: const [BoxShadow(color: Colors.black26)],
//         ),
//         child: _getDialogContent(context, children),
//       ),
//     );
//   }

//   Widget _getDialogContent(BuildContext context, List<Widget> children) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: children,
//     );
//   }

//   Widget _getItemsColumn(List<Widget> children) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: children,
//     );
//   }

//   Widget _getAnimatedImage(String animationName) {
//     return SizedBox(
//       height: AppSize.s100,
//       width: AppSize.s100,
//       child: Lottie.asset(animationName),
//     );
//   }

//   Widget _getMessage(String message) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(AppPadding.p8),
//         child: Text(
//           message,
//           style: getRegularStyle(
//             color: ColorManger.black,
//             fontSize: FontSize.s18,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _getRetryButton(String buttonTitle, BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(AppPadding.p18),
//         child: SizedBox(
//           width: double.infinity,
//           child: ElevatedButton(
//             onPressed: () {
//               if (stateRendererType == StateRendererType.fullScreenErrorState) {
//                 retryActionFunction.call();
//               } else {
//                 Navigator.of(context).pop();
//               }
//             },
//             child: Text(buttonTitle),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

enum StateRendererType {
  // popup states (Dialog)
  popupLoadingState,
  popupErrorStatete,
  // full screen states (full screen)
  fullScreenLoadingState,
  fullScreenErrorState,
  fullScreenEmptyState,
  successScreenState,
  // General state
  contentScreenState,
}

// ignore: must_be_immutable
class StateRandrer extends StatelessWidget {
  StateRendererType stateRendererType;
  String message;
  String title;
  Function retryAction;

  StateRandrer({
    super.key,
    required this.stateRendererType,
    this.message = AppStrings.loading,
    this.title = "",
    required this.retryAction,
  });

  @override
  Widget build(BuildContext context) {
    return _getStateWidget(context);
  }

  Widget _getStateWidget(BuildContext context) {
    switch (stateRendererType) {
      case StateRendererType.popupLoadingState:
        return _getPopupDialog(context, [
          _getAnimatedImage(JsonAssets.loading),
          _getTitle(title.isNotEmpty ? title : "جاري المعالجة..."),
          if (message.isNotEmpty &&
              message != AppStrings.loading &&
              message != title)
            _getMessage(message),
          const SizedBox(height: AppSize.s12),
        ]);

      case StateRendererType.popupErrorStatete:
        return _getPopupDialog(context, [
          _getAnimatedImage(JsonAssets.error),
          _getTitle(
            title.isNotEmpty ? title : "فشلت العملية",
            color: ColorManager.error,
          ),
          _getMessage(message.isNotEmpty ? message : AppStrings.defaultError),
          _getRetryButton(AppStrings.ok, context),
        ]);

      case StateRendererType.fullScreenLoadingState:
        return _getItemsColumn([
          _getAnimatedImage(JsonAssets.loading),
          _getTitle(title.isNotEmpty ? title : "جاري التحميل..."),
          if (message.isNotEmpty && message != AppStrings.loading)
            _getMessage(message),
        ]);

      case StateRendererType.fullScreenErrorState:
        return _getItemsColumn([
          _getAnimatedImage(JsonAssets.error),
          _getTitle(
            title.isNotEmpty ? title : "حدث خطأ",
            color: ColorManager.error,
          ),
          _getMessage(message.isNotEmpty ? message : AppStrings.defaultError),
          _getRetryButton(AppStrings.tryAgain, context),
        ]);

      case StateRendererType.fullScreenEmptyState:
        return _getItemsColumn([
          _getAnimatedImage(JsonAssets.empty),
          _getMessage(message.isNotEmpty ? message : "لا توجد بيانات متاحة"),
        ]);

      case StateRendererType.successScreenState:
        return _getPopupDialog(context, [
          _getAnimatedImage(JsonAssets.success),
          _getTitle(
            title.isNotEmpty ? title : AppStrings.success,
            color: ColorManager.brandGreen,
          ),
          if (message.isNotEmpty) _getMessage(message),
          _getRetryButton(AppStrings.ok, context),
        ]);

      case StateRendererType.contentScreenState:
        return const SizedBox.shrink();
    }
  }

  // popup dialog with rounded styling & shadow
  Widget _getPopupDialog(BuildContext context, List<Widget> children) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s18),
      ),
      elevation: AppSize.s4,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppPadding.p24),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p20,
          vertical: AppPadding.p24,
        ),
        decoration: BoxDecoration(
          color: ColorManager.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(AppSize.s18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: _getDialogContent(context, children),
      ),
    );
  }

  Widget _getDialogContent(BuildContext context, List<Widget> children) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }

  Widget _getItemsColumn(List<Widget> children) {
    return Material(
      color: ColorManager.background,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.p24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }

  Widget _getAnimatedImage(String animationPath) {
    return SizedBox(
      width: AppSize.s110,
      height: AppSize.s110,
      child: Lottie.asset(
        animationPath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(
          stateRendererType == StateRendererType.popupErrorStatete ||
                  stateRendererType == StateRendererType.fullScreenErrorState
              ? Icons.error_outline_rounded
              : Icons.hourglass_top_rounded,
          size: AppSize.s60,
          color:
              stateRendererType == StateRendererType.popupErrorStatete ||
                  stateRendererType == StateRendererType.fullScreenErrorState
              ? ColorManager.error
              : ColorManager.primary,
        ),
      ),
    );
  }

  Widget _getTitle(String titleText, {Color? color}) {
    if (titleText.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(
        top: AppPadding.p12,
        left: AppPadding.p12,
        right: AppPadding.p12,
        bottom: AppPadding.p4,
      ),
      child: Text(
        titleText,
        textAlign: TextAlign.center,
        style: getBoldStyle(
          color: color ?? ColorManager.textPrimary,
          fontSize: AppSize.s18,
        ),
      ),
    );
  }

  Widget _getMessage(String messageText) {
    if (messageText.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p16,
        vertical: AppPadding.p6,
      ),
      child: Text(
        messageText,
        textAlign: TextAlign.center,
        style: getRegularStyle(
          color: ColorManager.textSecondary,
          fontSize: AppSize.s14,
        ),
      ),
    );
  }

  Widget _getRetryButton(String buttonText, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppPadding.p20,
        left: AppPadding.p8,
        right: AppPadding.p8,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorManager.primary,
            foregroundColor: ColorManager.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.s12),
            ),
          ),
          onPressed: () {
            if (stateRendererType == StateRendererType.fullScreenErrorState) {
              retryAction.call();
            } else {
              Navigator.of(context).pop();
            }
          },
          child: Center(
            child: Text(
              buttonText,
              style: getBoldStyle(
                color: ColorManager.white,
                fontSize: AppSize.s16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
