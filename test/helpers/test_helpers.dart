import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Helper to create a testable widget with Riverpod ProviderScope
Widget createTestableWidget({
  required Widget child,
  List<Override>? overrides,
}) {
  return ProviderScope(
    overrides: overrides ?? [],
    child: MaterialApp(
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: child,
      ),
    ),
  );
}

/// Helper to pump a widget with Riverpod ProviderScope
Future<void> pumpWidgetWithProviders(
  WidgetTester tester, {
  required Widget widget,
  List<Override>? overrides,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides ?? [],
      child: widget,
    ),
  );
}

/// Helper to create a test MaterialApp with proper localization
Widget createTestApp({
  required Widget home,
  List<Override>? overrides,
  Locale locale = const Locale('ar', 'PS'),
}) {
  return ProviderScope(
    overrides: overrides ?? [],
    child: MaterialApp(
      locale: locale,
      home: home,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox(),
        );
      },
    ),
  );
}

/// Helper to wait for async operations in tests
Future<void> waitForAsync(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

/// Helper to verify text exists with Arabic support
Finder findArabicText(String text) {
  return find.text(text);
}

/// Helper to verify RTL layout
bool isRTL(BuildContext context) {
  return Directionality.of(context) == TextDirection.rtl;
}

/// Helper to tap and settle
Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Helper to enter text and settle
Future<void> enterTextAndSettle(
  WidgetTester tester,
  Finder finder,
  String text,
) async {
  await tester.enterText(finder, text);
  await tester.pumpAndSettle();
}

/// Helper to scroll until visible
Future<void> scrollUntilVisible(
  WidgetTester tester,
  Finder item,
  Finder scrollable, {
  double delta = 300.0,
}) async {
  await tester.scrollUntilVisible(
    item,
    delta,
    scrollable: scrollable,
  );
  await tester.pumpAndSettle();
}

/// Helper to verify widget tree structure
void verifyWidgetTree(WidgetTester tester, Type widgetType) {
  expect(find.byType(widgetType), findsOneWidget);
}

/// Helper to verify multiple widgets of same type
void verifyMultipleWidgets(WidgetTester tester, Type widgetType, int count) {
  expect(find.byType(widgetType), findsNWidgets(count));
}

/// Helper to verify no widget of type exists
void verifyNoWidget(WidgetTester tester, Type widgetType) {
  expect(find.byType(widgetType), findsNothing);
}

/// Helper for golden tests (screenshot comparison)
Future<void> expectGoldenMatches(
  WidgetTester tester,
  String goldenFileName,
) async {
  await tester.pumpAndSettle();
  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('goldens/$goldenFileName.png'),
  );
}

/// Helper to mock date/time for tests
class MockDateTime {
  static DateTime? _mockNow;

  static DateTime get now => _mockNow ?? DateTime.now();

  static void setMockNow(DateTime dateTime) {
    _mockNow = dateTime;
  }

  static void clearMock() {
    _mockNow = null;
  }
}

/// Helper to verify accessibility
Future<void> verifyAccessibility(WidgetTester tester) async {
  final SemanticsHandle handle = tester.ensureSemantics();
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  await expectLater(tester, meetsGuideline(textContrastGuideline));
  handle.dispose();
}
