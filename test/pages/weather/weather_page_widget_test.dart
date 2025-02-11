import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/cubits/cubits.dart';
import 'package:weather_app/models/display_weather.dart';
import 'package:weather_app/pages/weather/components/components.dart';
import 'package:weather_app/pages/weather/view/weather_page.dart';
import 'package:weather_repository/weather_repository.dart';

import '../../widget_test_bed.dart';

class MockWeatherCubit extends MockCubit<WeatherState>
    implements WeatherCubit {}

void main() {
  group('WeatherPage', () {
    late WeatherCubit weatherCubit;

    setUp(() {
      weatherCubit = MockWeatherCubit();
    });

    testWidgets('renders WeatherEmpty when state is initial', (tester) async {
      when(() => weatherCubit.state).thenReturn(WeatherState.initial());

      await tester.pumpWidget(
        WidgetTestbed().blocWrap(
          child: WeatherPage(),
          cubit: weatherCubit,
        ),
      );

      expect(find.byType(WeatherEmpty), findsOneWidget);
    });

    testWidgets('renders WeatherLoading when state is loading', (tester) async {
      when(() => weatherCubit.state).thenReturn(
          WeatherState.initial().copyWith(dataState: DataState.loading));

      await tester.pumpWidget(
        WidgetTestbed().blocWrap(
          child: WeatherPage(),
          cubit: weatherCubit,
        ),
      );

      expect(find.byType(WeatherLoading), findsOneWidget);
    });

    testWidgets('renders WeatherError when state is failure', (tester) async {
      when(() => weatherCubit.state).thenReturn(WeatherState.initial()
          .copyWith(dataState: DataState.failure, error: 'Error'));

      await tester.pumpWidget(
        WidgetTestbed().blocWrap(
          child: WeatherPage(),
          cubit: weatherCubit,
        ),
      );

      expect(find.byType(WeatherError), findsOneWidget);
      expect(find.text('Error'), findsOneWidget);
    });

    testWidgets('renders WeatherPopulated when state is success',
        (tester) async {
      final weather = _mockDisplayWeather;
      final location = _mockLocation;
      final forecast = [weather];

      when(() => weatherCubit.state).thenReturn(WeatherState.initial().copyWith(
        dataState: DataState.success,
        selectedWeather: weather,
        location: location,
        forecast: forecast,
      ));

      await tester.pumpWidget(
        WidgetTestbed().blocWrap(
          child: WeatherPage(),
          cubit: weatherCubit,
        ),
      );

      expect(find.byType(WeatherPopulated), findsOneWidget);
      expect(find.text('Test City'), findsOneWidget);
    });

    testWidgets('renders WeatherError when state has unexpected data',
        (tester) async {
      when(() => weatherCubit.state).thenReturn(WeatherState.initial().copyWith(
        dataState: DataState.failure,
        error: 'Unexpected data',
      ));

      await tester.pumpWidget(
        WidgetTestbed().blocWrap(
          child: WeatherPage(),
          cubit: weatherCubit,
        ),
      );

      expect(find.byType(WeatherError), findsOneWidget);
      expect(find.text('Unexpected data'), findsOneWidget);
    });

    testWidgets('renders WeatherError when state has unexpected data',
        (tester) async {
      when(() => weatherCubit.state).thenReturn(WeatherState.initial().copyWith(
        dataState: DataState.failure,
        error: 'Unexpected data',
      ));

      await tester.pumpWidget(
        WidgetTestbed().blocWrap(
          child: WeatherPage(),
          cubit: weatherCubit,
        ),
      );

      expect(find.byType(WeatherError), findsOneWidget);
      expect(find.text('Unexpected data'), findsOneWidget);
    });

    testWidgets('renders WeatherError when state has unexpected data',
        (tester) async {
      when(() => weatherCubit.state).thenReturn(WeatherState.initial().copyWith(
        dataState: DataState.failure,
        error: 'Unexpected data',
      ));

      await tester.pumpWidget(
        WidgetTestbed().blocWrap(
          child: WeatherPage(),
          cubit: weatherCubit,
        ),
      );

      expect(find.byType(WeatherError), findsOneWidget);
      expect(find.text('Unexpected data'), findsOneWidget);
    });
  });
}

final _mockDisplayWeather = DisplayWeather(
  description: 'Clear sky',
  iconCode: '01d',
  temperature: 25.0,
  pressure: 1013,
  humidity: 60,
  windSpeed: 5.0,
  date: DateTime.now(),
  condition: WeatherCondition.clear,
  unit: TemperatureUnit.celsius,
);

final _mockLocation = Location(
  name: 'Test City',
  country: 'Test Country',
  latitude: 1.0,
  longitude: 2.0,
);
