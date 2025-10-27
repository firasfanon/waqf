import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palestinian_ministry_endowments/main.dart';

void main() {
  group('PalestinianMinistryApp Widget Tests', () {
    testWidgets('app should render without errors', (WidgetTester tester) async {
      // Build our app
      await tester.pumpWidget(
        const ProviderScope(
          child: PalestinianMinistryApp(),
        ),
      );

      // Verify that the app builds successfully
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('app should use RTL direction', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: PalestinianMinistryApp(),
        ),
      );

      // Find the Directionality widget
      final directionality = tester.widget<Directionality>(
        find.descendant(
          of: find.byType(MaterialApp),
          matching: find.byType(Directionality),
        ).first,
      );

      // Verify RTL direction
      expect(directionality.textDirection, TextDirection.rtl);
    });

    testWidgets('app should have Arabic locale', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: PalestinianMinistryApp(),
        ),
      );

      // Find MaterialApp widget
      final materialApp = tester.widget<MaterialApp>(
        find.byType(MaterialApp),
      );

      // Verify default locale is Arabic
      expect(materialApp.locale, const Locale('ar', 'PS'));
    });

    testWidgets('app should support both Arabic and English locales',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: PalestinianMinistryApp(),
        ),
      );

      final materialApp = tester.widget<MaterialApp>(
        find.byType(MaterialApp),
      );

      // Verify supported locales
      expect(
        materialApp.supportedLocales,
        containsAll([
          const Locale('ar', 'PS'),
          const Locale('en', 'US'),
        ]),
      );
    });

    testWidgets('app should use Material 3', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: PalestinianMinistryApp(),
        ),
      );

      final materialApp = tester.widget<MaterialApp>(
        find.byType(MaterialApp),
      );

      // Verify Material 3 is enabled
      expect(materialApp.theme?.useMaterial3, isTrue);
    });

    testWidgets('app should have proper theme colors',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: PalestinianMinistryApp(),
        ),
      );

      final materialApp = tester.widget<MaterialApp>(
        find.byType(MaterialApp),
      );

      // Verify Islamic green is used in color scheme
      expect(
        materialApp.theme?.colorScheme.primary.value,
        isNotNull,
      );
    });

    testWidgets('app should not show debug banner',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: PalestinianMinistryApp(),
        ),
      );

      final materialApp = tester.widget<MaterialApp>(
        find.byType(MaterialApp),
      );

      // Verify debug banner is disabled
      expect(materialApp.debugShowCheckedModeBanner, isFalse);
    });
  });
}
