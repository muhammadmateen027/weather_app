import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/cubits/weather/weather_cubit.dart';
import 'package:weather_app/models/models.dart';
import 'package:weather_repository/weather_repository.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

final _fixedDateTime = DateTime(2025, 1, 27, 10, 33, 47, 329720);

void main() {
  group('WeatherCubit', () {
    late WeatherRepository weatherRepository;
    late WeatherCubit weatherCubit;
    late _ArrangeBuilder builder;

    setUp(() {
      builder = _ArrangeBuilder();
      weatherRepository = MockWeatherRepository();
      weatherCubit = WeatherCubit(weatherRepository);
    });

    tearDown(() {
      weatherCubit.close();
    });

    test('initial state is WeatherState.initial()', () {
      expect(weatherCubit.state, WeatherState.initial());
    });

    blocTest<WeatherCubit, WeatherState>(
      'does not emit new states when fetchWeather is called with null or empty city',
      build: () => weatherCubit,
      act: (cubit) => cubit.fetchWeather(null),
      expect: () => [],
    );

    blocTest<WeatherCubit, WeatherState>(
      'does not emit new states when fetchWeather is called with empty city',
      build: () => weatherCubit,
      act: (cubit) => cubit.fetchWeather(''),
      expect: () => [],
    );

    blocTest<WeatherCubit, WeatherState>(
      'emits [loading, success] when fetchWeather succeeds',
      build: () {
        final weather = WeatherForecast(
          location: builder.location,
          list: [builder.weatherData],
        );
        when(() => weatherRepository.getWeatherByCity(any()))
            .thenAnswer((_) async => weather);
        return weatherCubit;
      },
      act: (cubit) => cubit.fetchWeather('Test City'),
      expect: () => [
        WeatherState.initial().copyWith(dataState: DataState.loading),
        WeatherState.initial().copyWith(
          dataState: DataState.success,
          location: builder.location,
          selectedWeather: DisplayWeather.fromRepository(
            builder.weatherData,
            TemperatureUnit.celsius,
          ),
          forecast: [
            DisplayWeather.fromRepository(
              builder.weatherData,
              TemperatureUnit.celsius,
            ),
          ],
        ),
      ],
    );

    blocTest<WeatherCubit, WeatherState>(
      'emits [loading, failure] when fetchWeather fails',
      build: () {
        when(() => weatherRepository.getWeatherByCity(any()))
            .thenThrow(Exception('Failed to fetch weather'));
        return weatherCubit;
      },
      act: (cubit) => cubit.fetchWeather('Test City'),
      expect: () => [
        WeatherState.initial().copyWith(dataState: DataState.loading),
        WeatherState.initial().copyWith(dataState: DataState.failure),
      ],
    );
  });
}

class _ArrangeBuilder {
  Location location = Location(
    name: 'name',
    country: 'country',
    latitude: 12.2,
    longitude: 232.32,
  );
  WeatherData weatherData = WeatherData(
    temperature: 20,
    pressure: 1013,
    humidity: 72,
    windSpeed: 4.6,
    condition: 'Clear',
    description: 'clear sky',
    iconCode: '01d',
    date: _fixedDateTime,
  );
}
