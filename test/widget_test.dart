import 'package:flutter_test/flutter_test.dart';
import 'package:mizan/app/app.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';

void main() {
  testWidgets('App launches with SplashView and branding', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    // Pump 400ms into logo entrance animation
    await tester.pump(const Duration(milliseconds: 400));

    // Verify that the splash screen renders the branding
    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.appNameEn), findsOneWidget);

    // Pump to complete logo animation
    await tester.pump(const Duration(milliseconds: 400));

    // Verify loading indicator is now visible
    expect(find.text(AppStrings.loading), findsOneWidget);
  });

  testWidgets('SplashView navigates to OnBoardingView upon completion', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // 1. Advance logo animation to completion (800ms in 100ms steps)
    for (int i = 0; i < 9; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // 2. Advance progress animation to completion (2200ms in 100ms steps)
    for (int i = 0; i < 24; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // 3. Advance route transition (400ms in 100ms steps)
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // Verify navigation to OnBoardingView has completed
    expect(find.text(AppStrings.onBoardingTitle1), findsOneWidget);
  });
}
