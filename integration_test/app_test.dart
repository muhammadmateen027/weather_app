import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:weather_repository/weather_repository.dart';

import '../test/widget_test_bed.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final repository = WeatherRepository(
    apiKey: const String.fromEnvironment('WEATHER_API_KEY'),
  );

  group('Search Page Integration Tests', () {
    testWidgets('renders search page UI elements correctly', (tester) async {
      await tester.pumpWidget(
        WidgetTestbed().pumpAppWithRepo(repository: repository),
      );
      await tester.pumpAndSettle();

      // Navigate to search page
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify AppBar
      expect(find.text('City Search'), findsOneWidget);

      // Verify TextField properties
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);
      expect(find.text('City'), findsOneWidget);
      expect(find.text('Berlin'), findsOneWidget);

      // Verify search button
      final searchButton =
          find.byKey(const Key('searchPage_search_iconButton'));
      expect(searchButton, findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.bySemanticsLabel('Submit'), findsOneWidget);
    });

    testWidgets('search functionality via button tap', (tester) async {
      await tester.pumpWidget(
        WidgetTestbed().pumpAppWithRepo(repository: repository),
      );
      await tester.pumpAndSettle();

      // Navigate to search page
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      const cityName = 'London';
      await tester.enterText(find.byType(TextField), cityName);
      await tester.tap(find.byKey(const Key('searchPage_search_iconButton')));
      await tester.pumpAndSettle();

      // Verify weather data is displayed
      expect(find.text(cityName), findsOneWidget);
    });

    testWidgets('search functionality via keyboard submit', (tester) async {
      await tester.pumpWidget(
        WidgetTestbed().pumpAppWithRepo(repository: repository),
      );
      await tester.pumpAndSettle();

      // Navigate to search page
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      const cityName = 'Paris';
      await tester.enterText(find.byType(TextField), cityName);
      await tester.testTextInput.receiveAction(TextInputAction.done);

      // Wait for navigation and data loading
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Verify weather data is displayed
      expect(find.byType(Card), findsWidgets);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('handles invalid city search gracefully', (tester) async {
      await tester.pumpWidget(
        WidgetTestbed().pumpAppWithRepo(repository: repository),
      );
      await tester.pumpAndSettle();

      // Navigate to search page
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Enter invalid city name
      await tester.enterText(find.byType(TextField), 'InvalidCityXYZ123');
      await tester.tap(find.byKey(const Key('searchPage_search_iconButton')));

      // Wait for API response and UI update
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Verify error state on the weather page after navigation
      expect(find.textContaining('City not found'), findsOneWidget);
    });
  });
}
