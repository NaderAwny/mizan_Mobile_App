import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mizan/presentation/resources/constants_manager.dart';
import 'package:mizan/presentation/resources/routes_manager.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';
import 'package:mizan/presentation/resources/them_manager.dart';

Widget createOnboardingScreen() {
  return ScreenUtilInit(
    designSize: AppConstants.designSize,
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context, child) {
      return MaterialApp(
        theme: getApplicationTheme(),
        initialRoute: Routes.onBoardingRoute,
        onGenerateRoute: RouteGenerator.getRoute,
      );
    },
  );
}

void main() {
  testWidgets('OnBoarding initial screen renders properly', (WidgetTester tester) async {
    await tester.pumpWidget(createOnboardingScreen());
    await tester.pumpAndSettle();

    // Verify first slide content
    expect(find.text(AppStrings.onBoardingTitle1), findsOneWidget);
    expect(find.text(AppStrings.skip), findsOneWidget);
    expect(find.text(AppStrings.next), findsOneWidget);
  });

  testWidgets('Skip button moves to the last page (slide 3), shows startNow and removes skip', (WidgetTester tester) async {
    await tester.pumpWidget(createOnboardingScreen());
    await tester.pumpAndSettle();

    // Tap Skip button
    await tester.tap(find.text(AppStrings.skip));
    await tester.pumpAndSettle();

    // Verify last slide title (Slide 3)
    expect(find.text(AppStrings.onBoardingTitle3), findsOneWidget);

    // Skip button should now be gone from the AppBar
    expect(find.text(AppStrings.skip), findsNothing);

    // Button should now show "ابدأ الآن"
    expect(find.text(AppStrings.startNow), findsOneWidget);
    expect(find.text(AppStrings.next), findsNothing);
  });

  testWidgets('Next button advances pages one by one to slide 3 and navigates to login', (WidgetTester tester) async {
    await tester.pumpWidget(createOnboardingScreen());
    await tester.pumpAndSettle();

    // Slide 1
    expect(find.text(AppStrings.onBoardingTitle1), findsOneWidget);

    // Tap Next -> Slide 2
    await tester.tap(find.text(AppStrings.next));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.onBoardingTitle2), findsOneWidget);

    // Tap Next -> Slide 3 (last slide)
    await tester.tap(find.text(AppStrings.next));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.onBoardingTitle3), findsOneWidget);
    expect(find.text(AppStrings.startNow), findsOneWidget);

    // Tap "ابدأ الآن" navigates to loginRoute
    await tester.tap(find.text(AppStrings.startNow));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.loginTitle), findsWidgets);
  });

  testWidgets('AppBar shows both the logo icon and the text "ميزان"', (WidgetTester tester) async {
    await tester.pumpWidget(createOnboardingScreen());
    await tester.pumpAndSettle();

    // Verify both app name "ميزان" and logo icon appear in the header
    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.byType(Image), findsWidgets);
    expect(find.text(AppStrings.skip), findsOneWidget);
  });

  testWidgets('OnBoardingView is fully responsive on small screens with enlarged text scale', (WidgetTester tester) async {
    // Configure small screen (iPhone SE / 5s size: 320x568)
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    // Set enlarged accessibility font scale (1.5x)
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.platformDispatcher.clearTextScaleFactorTestValue();
    });

    await tester.pumpWidget(createOnboardingScreen());
    await tester.pumpAndSettle();

    // Verify "تخطي" exists and renders on 1 line without overflow
    final skipFinder = find.text(AppStrings.skip);
    expect(skipFinder, findsOneWidget);
    final Text skipWidget = tester.widget(skipFinder);
    expect(skipWidget.maxLines, 1);
    expect(skipWidget.softWrap, false);

    // Verify logo and text exist
    expect(find.text(AppStrings.appName), findsOneWidget);

    // Verify next button is clickable and no RenderFlex overflow occurs
    await tester.tap(find.text(AppStrings.next));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.onBoardingTitle2), findsOneWidget);

    // Jump to last page via skip button
    await tester.tap(find.text(AppStrings.skip));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.onBoardingTitle3), findsOneWidget);
    expect(find.text(AppStrings.startNow), findsOneWidget);
  });
}
