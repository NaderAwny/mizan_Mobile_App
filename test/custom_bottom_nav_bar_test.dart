import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mizan/presentation/home/widgets/custom_bottom_nav_bar.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';

void main() {
  testWidgets(
    'CustomBottomNavBar renders all 5 items with center Transactions button',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.75;
      addTearDown(() => tester.view.resetPhysicalSize());

      int selectedIndex = 0;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(402, 874),
          builder: (BuildContext context, Widget? child) => MaterialApp(
            locale: const Locale('ar'),
            home: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Scaffold(
                  bottomNavigationBar: CustomBottomNavBar(
                    currentIndex: selectedIndex,
                    onTap: (int index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Verify all 5 navigation destination labels are present simultaneously
      expect(find.text(AppStrings.home), findsOneWidget); // الرئيسية
      expect(find.text(AppStrings.transactions), findsOneWidget); // المعاملات
      expect(find.text(AppStrings.contacts), findsOneWidget); // العملاء
      expect(find.text(AppStrings.installments), findsOneWidget); // الأقساط
      expect(find.text(AppStrings.analytics), findsOneWidget); // التقارير

      // 2. Verify no horizontal scrolling widget is used
      expect(find.byType(SingleChildScrollView), findsNothing);

      // 3. Verify tapping center button selects tab 1 (Transactions)
      await tester.tap(find.text(AppStrings.transactions));
      await tester.pumpAndSettle();
      expect(selectedIndex, 1);

      // 4. Verify tapping contacts selects tab 2
      await tester.tap(find.text(AppStrings.contacts));
      await tester.pumpAndSettle();
      expect(selectedIndex, 2);

      // 5. Verify tapping installments selects tab 3
      await tester.tap(find.text(AppStrings.installments));
      await tester.pumpAndSettle();
      expect(selectedIndex, 3);

      // 6. Verify tapping analytics selects tab 4
      await tester.tap(find.text(AppStrings.analytics));
      await tester.pumpAndSettle();
      expect(selectedIndex, 4);

      // 7. Verify tapping home selects tab 0
      await tester.tap(find.text(AppStrings.home));
      await tester.pumpAndSettle();
      expect(selectedIndex, 0);
    },
  );
}
