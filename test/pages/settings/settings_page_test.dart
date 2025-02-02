import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/cubits/weather/weather_cubit.dart';
import 'package:weather_app/pages/settings/view/settings_page.dart';

import '../../test_bed.dart';

class MockWeatherCubit extends Mock implements WeatherCubit {
  @override
  Stream<WeatherState> get stream => Stream.value(state);
}

void main() {
  late WeatherCubit weatherCubit;

  setUp(() {
    weatherCubit = MockWeatherCubit();
    when(() => weatherCubit.stream)
        .thenAnswer((_) => Stream.value(WeatherState.initial()));
  });

  group('SettingsPage', () {
    testWidgets('renders correct title in AppBar', (tester) async {
      when(() => weatherCubit.state).thenReturn(WeatherState.initial());

      await tester.pumpWidget(
        WidgetTestbed().blocWrap(child: SettingsPage(), cubit: weatherCubit),
      );

      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('renders temperature units switch', (tester) async {
      when(() => weatherCubit.state).thenReturn(WeatherState.initial());

      await tester.pumpWidget(
        WidgetTestbed().blocWrap(child: SettingsPage(), cubit: weatherCubit),
      );

      expect(find.text('Temperature Units'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('calls toggleTemperatureUnit when switch is tapped',
        (tester) async {
      when(() => weatherCubit.state).thenReturn(WeatherState.initial());
      when(() => weatherCubit.toggleTemperatureUnit()).thenReturn(null);

      await tester.pumpWidget(
        WidgetTestbed().blocWrap(child: SettingsPage(), cubit: weatherCubit),
      );

      await tester.tap(find.byType(Switch));
      verify(() => weatherCubit.toggleTemperatureUnit()).called(1);
    });
  });
}
