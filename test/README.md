# Testing Guide

This directory contains all tests for the Palestinian Ministry of Endowments Flutter application.

## Directory Structure

```
test/
├── unit/              # Unit tests for business logic, utilities, and models
├── widget/            # Widget tests for UI components
├── integration/       # Integration tests for complete user flows
├── helpers/           # Test helper functions and utilities
├── mocks/             # Mock objects for testing
├── fixtures/          # Test data and fixtures
└── README.md          # This file
```

## Test Types

### Unit Tests (`test/unit/`)

Unit tests focus on testing individual functions, classes, and utilities in isolation.

**Examples:**
- Testing `AppConstants` values and validation
- Testing utility functions and extensions
- Testing data models and serialization
- Testing repository logic
- Testing service methods

**Location Pattern:**
```
test/unit/<feature>/<file>_test.dart
```

**Example:**
```dart
// test/unit/core/constants/app_constants_test.dart
test('should have 16 Palestinian governorates', () {
  expect(AppConstants.governorates.length, 16);
});
```

### Widget Tests (`test/widget/`)

Widget tests verify that UI components render correctly and respond to user interactions.

**Examples:**
- Testing widgets render without errors
- Testing user interactions (taps, scrolls, text input)
- Testing widget state changes
- Testing navigation
- Testing accessibility

**Location Pattern:**
```
test/widget/<feature>_test.dart
```

**Example:**
```dart
// test/widget/app_test.dart
testWidgets('app should use RTL direction', (WidgetTester tester) async {
  await tester.pumpWidget(const ProviderScope(child: PalestinianMinistryApp()));
  expect(directionality.textDirection, TextDirection.rtl);
});
```

### Integration Tests (`test/integration/`)

Integration tests verify complete user flows and feature interactions.

**Examples:**
- User login flow
- News browsing and filtering
- Mosque search and navigation
- Form submission workflows

**Note:** Integration tests should be placed in the `integration_test/` directory at the project root for proper Flutter Driver support.

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/unit/core/constants/app_constants_test.dart
```

### Run Tests by Directory
```bash
# Unit tests only
flutter test test/unit/

# Widget tests only
flutter test test/widget/
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

### View Coverage Report
```bash
# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open in browser
open coverage/html/index.html
```

### Run Tests in Watch Mode
```bash
# Watch for changes and re-run tests
flutter test --watch
```

## Test Helpers

### Test Helper Functions (`test/helpers/test_helpers.dart`)

Utility functions to simplify common testing tasks:

```dart
// Create testable widget with providers
Widget createTestableWidget({
  required Widget child,
  List<Override>? overrides,
});

// Pump widget with Riverpod support
Future<void> pumpWidgetWithProviders(
  WidgetTester tester, {
  required Widget widget,
  List<Override>? overrides,
});

// Create test app with proper localization
Widget createTestApp({
  required Widget home,
  List<Override>? overrides,
  Locale locale = const Locale('ar', 'PS'),
});

// Tap and wait for animations
Future<void> tapAndSettle(WidgetTester tester, Finder finder);

// Enter text and wait
Future<void> enterTextAndSettle(WidgetTester tester, Finder finder, String text);
```

### Mock Objects (`test/mocks/`)

Pre-configured mock objects for common dependencies:

```dart
// Mock Supabase client
MockSupabaseClient createMockSupabaseClient({
  MockUser? user,
  MockSession? session,
});

// Mock authenticated user
MockUser createMockUser({
  String id = 'test-user-id',
  String email = 'test@example.com',
});
```

### Test Fixtures (`test/fixtures/test_data.dart`)

Sample data for testing:

```dart
// Sample news article
const sampleNewsArticleJson = { ... };

// Sample mosque data
const sampleMosqueJson = { ... };

// Generate multiple test items
List<Map<String, dynamic>> createMultipleNewsArticles(int count);
```

## Writing Good Tests

### Best Practices

1. **Descriptive Names**: Use clear, descriptive test names
   ```dart
   test('should return list of mosques when API call succeeds', () { ... });
   ```

2. **Arrange-Act-Assert**: Structure tests clearly
   ```dart
   test('example', () {
     // Arrange: Set up test data
     final data = createTestData();

     // Act: Perform the action
     final result = performAction(data);

     // Assert: Verify the result
     expect(result, expectedValue);
   });
   ```

3. **One Assertion Focus**: Each test should verify one specific behavior

4. **Independent Tests**: Tests should not depend on each other

5. **Clean Up**: Dispose resources and reset state
   ```dart
   tearDown(() {
     // Clean up after each test
   });
   ```

6. **Use Test Groups**: Organize related tests
   ```dart
   group('AppConstants', () {
     group('Contact Information', () {
       test('should have valid email', () { ... });
       test('should have valid phone', () { ... });
     });
   });
   ```

### Testing Async Code

```dart
test('async operation completes successfully', () async {
  final result = await asyncOperation();
  expect(result, isNotNull);
});
```

### Testing Widgets with Riverpod

```dart
testWidgets('widget updates when provider changes', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        myProvider.overrideWith((ref) => 'test value'),
      ],
      child: MyWidget(),
    ),
  );

  expect(find.text('test value'), findsOneWidget);
});
```

### Testing RTL Layouts

```dart
testWidgets('layout should support RTL', (tester) async {
  await tester.pumpWidget(createTestApp(home: MyScreen()));

  final directionality = tester.widget<Directionality>(
    find.byType(Directionality).first,
  );

  expect(directionality.textDirection, TextDirection.rtl);
});
```

## Code Coverage Goals

- **Target**: 70% overall coverage
- **Unit Tests**: 80%+ coverage for business logic
- **Widget Tests**: 60%+ coverage for UI components
- **Critical Paths**: 90%+ coverage for authentication, payments, etc.

## Continuous Integration

Tests are automatically run on every pull request. All tests must pass before merging.

```yaml
# GitHub Actions example
- name: Run tests
  run: flutter test --coverage

- name: Check coverage
  run: |
    COVERAGE=$(lcov --summary coverage/lcov.info | grep "lines" | cut -d ' ' -f 4)
    if [ "${COVERAGE%\%}" -lt 70 ]; then
      echo "Coverage ${COVERAGE} is below 70%"
      exit 1
    fi
```

## Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)
- [Mockito Documentation](https://pub.dev/packages/mockito)
- [Riverpod Testing](https://riverpod.dev/docs/cookbooks/testing)

## Contributing

When adding new features:

1. Write tests **before** or **alongside** implementation
2. Ensure tests cover happy paths and edge cases
3. Test error handling and validation
4. Add integration tests for complete user flows
5. Run tests locally before pushing
6. Update this guide if adding new testing patterns

## Example Test Patterns

### Testing Form Validation

```dart
testWidgets('email field shows error for invalid input', (tester) async {
  await tester.pumpWidget(createTestApp(home: LoginScreen()));

  await enterTextAndSettle(tester, find.byType(TextField), 'invalid');
  await tapAndSettle(tester, find.text('تسجيل الدخول'));

  expect(find.text('البريد الإلكتروني غير صحيح'), findsOneWidget);
});
```

### Testing Navigation

```dart
testWidgets('tapping news card navigates to detail screen', (tester) async {
  await tester.pumpWidget(createTestApp(home: HomeScreen()));

  await tapAndSettle(tester, find.byType(NewsCard).first);

  expect(find.byType(NewsDetailScreen), findsOneWidget);
});
```

### Testing API Calls

```dart
test('fetchNews returns list when API call succeeds', () async {
  final mockClient = createMockSupabaseClient();
  final repository = NewsRepository(mockClient);

  when(mockClient.from('news').select()).thenAnswer(
    (_) async => [sampleNewsArticleJson],
  );

  final result = await repository.fetchNews();

  expect(result, isNotEmpty);
  expect(result.first.title, 'افتتاح مسجد جديد في رام الله');
});
```

---

**Happy Testing! 🧪**
