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
      when(
        () => weatherRepository.getWeatherByCity(any()),
      ).thenAnswer((_) async => builder.weatherForecast);
      weatherCubit = WeatherCubit(weatherRepository);
    });

    tearDown(() {
      weatherCubit.close();
    });

    test('initial state is WeatherState.initial()', () {
      expect(weatherCubit.state, WeatherState.initial());
    });

    group('fetchWeather', () {
      blocTest<WeatherCubit, WeatherState>(
        'emits nothing when city is null',
        build: () => weatherCubit,
        act: (cubit) => cubit.fetchWeather(null),
        expect: () => <WeatherState>[],
      );

      blocTest<WeatherCubit, WeatherState>(
        'emits nothing when city is empty',
        build: () => weatherCubit,
        act: (cubit) => cubit.fetchWeather(''),
        expect: () => <WeatherState>[],
      );

      blocTest<WeatherCubit, WeatherState>(
        'calls getWeather with correct city',
        build: () {
          final weather = builder.weatherForecast;

          when(() => weatherRepository.getWeatherByCity(any()))
              .thenAnswer((_) async => weather);
          return weatherCubit;
        },
        act: (cubit) => cubit.fetchWeather(builder.weatherLocation),
        verify: (_) {
          verify(() =>
                  weatherRepository.getWeatherByCity(builder.weatherLocation))
              .called(1);
        },
      );

      blocTest<WeatherCubit, WeatherState>(
        'emits [loading, failure] when getWeather throws',
        setUp: () {
          when(
            () => weatherRepository.getWeatherByCity(any()),
          ).thenThrow(WeatherRequestFailureException());
        },
        build: () => weatherCubit,
        act: (cubit) => cubit.fetchWeather(builder.weatherLocation),
        expect: () => <WeatherState>[
          WeatherState.initial().copyWith(
            dataState: DataState.loading,
            searchedCityName: builder.weatherLocation,
          ),
          WeatherState.initial().copyWith(
            dataState: DataState.failure,
            error: 'Failed to fetch weather',
            searchedCityName: builder.weatherLocation,
          ),
        ],
      );

      blocTest<WeatherCubit, WeatherState>(
        'emits [loading, success] when getWeather returns (celsius)',
        build: () {
          final weather = builder.weatherForecast;

          when(() => weatherRepository.getWeatherByCity(any()))
              .thenAnswer((_) async => weather);
          return weatherCubit;
        },
        act: (cubit) => cubit.fetchWeather(builder.weatherLocation),
        expect: () => <dynamic>[
          WeatherState.initial().copyWith(
            dataState: DataState.loading,
            searchedCityName: builder.weatherLocation,
          ),
          isA<WeatherState>()
              .having((w) => w.dataState, 'dataState', DataState.success)
              .having(
                (w) => w.selectedWeather,
                'weather',
                isA<DisplayWeather>()
                    .having(
                        (w) => w.condition, 'condition', WeatherCondition.clear)
                    .having((w) => w.temperature, 'temperature', 20)
                    .having((w) => w.unit, 'unit', TemperatureUnit.celsius),
              ),
        ],
      );
      blocTest<WeatherCubit, WeatherState>(
        'emits [loading, success] when getWeather returns (fahrenheit)',
        build: () {
          final weather = builder.weatherForecast;

          when(() => weatherRepository.getWeatherByCity(any()))
              .thenAnswer((_) async => weather);
          return weatherCubit;
        },
        seed: () => WeatherState.initial()
            .copyWith(temperatureUnit: TemperatureUnit.fahrenheit),
        act: (cubit) => cubit.fetchWeather(builder.weatherLocation),
        expect: () => <WeatherState>[
          WeatherState.initial().copyWith(
            dataState: DataState.loading,
            temperatureUnit: TemperatureUnit.fahrenheit,
            searchedCityName: builder.weatherLocation,
          ),
          WeatherState(
            dataState: DataState.success,
            selectedWeather: DisplayWeather.fromRepository(
              builder.weatherData,
              TemperatureUnit.fahrenheit,
            ),
            forecast: [
              DisplayWeather.fromRepository(
                builder.weatherData,
                TemperatureUnit.fahrenheit,
              ),
            ],
            location: builder.location,
            temperatureUnit: TemperatureUnit.fahrenheit,
            searchedCityName: builder.weatherLocation,
          ),
        ],
      );
    });
  });
}

class _ArrangeBuilder {
  final weatherLocation = 'London';

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

  List<WeatherData> weathers = [
    WeatherData(
      temperature: 20,
      pressure: 1013,
      humidity: 72,
      windSpeed: 4.6,
      condition: 'Clear',
      description: 'clear sky',
      iconCode: '01d',
      date: _fixedDateTime,
    ),
  ];

  WeatherForecast weatherForecast = WeatherForecast(
    location: Location(
      name: 'name',
      country: 'country',
      latitude: 12.2,
      longitude: 232.32,
    ),
    list: [
      WeatherData(
        temperature: 20,
        pressure: 1013,
        humidity: 72,
        windSpeed: 4.6,
        condition: 'Clear',
        description: 'clear sky',
        iconCode: '01d',
        date: _fixedDateTime,
      ),
    ],
  );
}
