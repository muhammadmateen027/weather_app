import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/cubits/weather/weather_cubit.dart';
import 'package:weather_app/pages/search/view/search_page.dart';

import '../../test_bed.dart';

class MockWeatherCubit extends Mock implements WeatherCubit {}

void main() {
  late WeatherCubit weatherCubit;

  setUp(() {
    weatherCubit = MockWeatherCubit();
  });

  group('SearchPage', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(WidgetTestbed().blocWrap(
        child: const SearchPage(),
        cubit: weatherCubit,
      ));

      expect(find.text('City Search'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('Search page UI elements', (tester) async {
      await tester.pumpWidget(WidgetTestbed().blocWrap(
        child: const SearchPage(),
        cubit: weatherCubit,
      ));
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

    testWidgets('calls fetchWeather and pops when search button is tapped',
        (tester) async {
      const cityName = 'London';

      // Initialize the stream for the mock cubit
      when(() => weatherCubit.stream).thenAnswer(
        (_) => Stream.fromIterable([WeatherState.initial()]),
      );

      when(() => weatherCubit.fetchWeather(any())).thenAnswer((_) async {});

      await tester.pumpWidget(WidgetTestbed().blocWrap(
        child: const SearchPage(),
        cubit: weatherCubit,
      ));

      await tester.enterText(find.byType(TextField), cityName);
      await tester.tap(find.byKey(const Key('searchPage_search_iconButton')));
      await tester.pumpAndSettle();

      verify(() => weatherCubit.fetchWeather(cityName)).called(1);
    });

    testWidgets('calls fetchWeather when enter is pressed', (tester) async {
      const cityName = 'Paris';

      // Set up the stream mock
      when(() => weatherCubit.stream).thenAnswer(
        (_) => Stream.fromIterable([WeatherState.initial()]),
      );

      when(() => weatherCubit.fetchWeather(any())).thenAnswer((_) async {});

      await tester.pumpWidget(WidgetTestbed().blocWrap(
        child: const SearchPage(),
        cubit: weatherCubit,
      ));

      await tester.enterText(find.byType(TextField), cityName);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      verify(() => weatherCubit.fetchWeather(cityName)).called(1);
    });
  });
}
