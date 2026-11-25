import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizan/app/di.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/notifications/run_reminders_scan/run_reminders_scan_cubit.dart';
import 'package:mizan/presentation/notifications/run_reminders_scan/run_reminders_scan_state.dart';
import 'package:mizan/presentation/resources/assets_manager.dart';
import 'package:mizan/presentation/resources/color_manager.dart';
import 'package:mizan/presentation/resources/font_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/styles_manager.dart';
import 'package:mizan/presentation/resources/values_manager.dart';

Future<void> showRunRemindersSheet({
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: ColorManager.transparent,
    barrierColor: ColorManager.black.withAlpha(90),
    builder: (_) => BlocProvider<RunRemindersScanCubit>(
      create: (_) => getIt<RunRemindersScanCubit>(),
      child: _RunRemindersSheet(onSuccess: onSuccess),
    ),
  );
}

class _RunRemindersSheet extends StatelessWidget {
  final VoidCallback onSuccess;

  const _RunRemindersSheet({required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocConsumer<RunRemindersScanCubit, RunRemindersScanState>(
        listenWhen:
            (RunRemindersScanState previous, RunRemindersScanState current) =>
                current.isSuccess && current.result != null,
        listener: (BuildContext context, RunRemindersScanState state) {
          if (state.isSuccess && state.result != null) {
            final int count = state.result!.remindersProcessed;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${AppStrings.runRemindersDone}: $count ${AppStrings.runRemindersProcessedSuffix}',
                  style: getMediumStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s13,
                  ),
                ),
                backgroundColor: ColorManager.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
            onSuccess();
            Navigator.of(context).pop();
          }
        },
        builder: (BuildContext context, RunRemindersScanState state) {
          final Widget content = Container(
            decoration: BoxDecoration(
              color: ColorManager.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
            ),
            padding: EdgeInsets.fromLTRB(
              20.w,
              0,
              20.w,
              MediaQuery.of(context).viewInsets.bottom + 24.h,
            ),
            child: const _SheetBody(),
          );

          return state.flowState?.getScreenWidget(
                context,
                content,
                () => context.read<RunRemindersScanCubit>().run(),
              ) ??
              content;
        },
      ),
    );
  }
}

class _SheetBody extends StatelessWidget {
  const _SheetBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const _DragHandle(),
        const _HeaderIcon(),
        SizedBox(height: 12.h),
        Text(
          AppStrings.runRemindersTitle,
          textAlign: TextAlign.center,
          style: getExtraBoldStyle(
            color: ColorManager.textPrimary,
            fontSize: FontSize.s18,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          AppStrings.runRemindersDescription,
          textAlign: TextAlign.center,
          style: getRegularStyle(
            color: ColorManager.textSecondary,
            fontSize: FontSize.s13,
            height: 1.4,
          ),
        ),
        SizedBox(height: 16.h),
        const _RemindersBulletsCard(),
        SizedBox(height: 12.h),
        const _NoEmailNoteBanner(),
        SizedBox(height: 20.h),
        const _ActionButtons(),
      ],
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 12.h, bottom: 16.h),
        width: 44.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: ColorManager.border,
          borderRadius: BorderRadius.circular(AppRadius.r999.r),
        ),
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 60.r,
        height: 60.r,
        decoration: BoxDecoration(
          color: ColorManager.lightPrimary,
          shape: BoxShape.circle,
          border: Border.all(
            color: ColorManager.primary.withAlpha(45),
            width: 1.5,
          ),
        ),
        child: Center(
          child: SvgPicture.asset(
            IconAssets.mailPlus,
            width: 28.r,
            height: 28.r,
            colorFilter: const ColorFilter.mode(
              ColorManager.primary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

class _RemindersBulletsCard extends StatelessWidget {
  const _RemindersBulletsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: ColorManager.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.r14.r),
        border: Border.all(color: ColorManager.border, width: 1),
      ),
      child: Column(
        children: <Widget>[
          const _BulletRow(
            icon: IconAssets.bell,
            text: AppStrings.runRemindersInApp,
          ),
          SizedBox(height: 10.h),
          Divider(color: ColorManager.border, height: 1.h),
          SizedBox(height: 10.h),
          const _BulletRow(
            icon: IconAssets.mailPlus,
            text: AppStrings.runRemindersEmail,
          ),
        ],
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  final String icon;
  final String text;

  const _BulletRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 28.r,
          height: 28.r,
          decoration: const BoxDecoration(
            color: ColorManager.lightPrimary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              icon,
              width: 14.r,
              height: 14.r,
              colorFilter: const ColorFilter.mode(
                ColorManager.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            text,
            style: getMediumStyle(
              color: ColorManager.textPrimary,
              fontSize: FontSize.s13,
            ),
          ),
        ),
      ],
    );
  }
}

class _NoEmailNoteBanner extends StatelessWidget {
  const _NoEmailNoteBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: ColorManager.lightSecondary.withAlpha(80),
        borderRadius: BorderRadius.circular(AppRadius.r12.r),
        border: Border.all(
          color: ColorManager.secondary.withAlpha(60),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.info_outline_rounded,
            size: 18.r,
            color: ColorManager.secondary,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              AppStrings.runRemindersNoEmailNote,
              style: getRegularStyle(
                color: ColorManager.textSecondary,
                fontSize: FontSize.s11,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: ElevatedButton(
            onPressed: () => context.read<RunRemindersScanCubit>().run(),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.primary,
              foregroundColor: ColorManager.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.r12.r),
              ),
              elevation: 0,
            ),
            child: Text(
              AppStrings.runRemindersConfirm,
              style: getBoldStyle(
                color: ColorManager.white,
                fontSize: FontSize.s14,
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          width: double.infinity,
          height: 40.h,
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppStrings.cancel,
              style: getMediumStyle(
                color: ColorManager.textSecondary,
                fontSize: FontSize.s13,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
