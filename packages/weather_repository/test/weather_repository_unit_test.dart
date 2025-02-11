import 'package:mocktail/mocktail.dart';
import 'package:open_weather_api/open_weather_api.dart';
import 'package:test/test.dart';
import 'package:weather_repository/weather_repository.dart';

class MockOpenWeatherApiClient extends Mock implements OpenWeatherApiClient {}

class CoordDtoFake extends Fake implements CoordDto {}

void main() {
  late MockOpenWeatherApiClient mockOpenWeatherApiClient;
  late WeatherRepository weatherRepository;

  setUpAll(() {
    registerFallbackValue(CoordDtoFake());
  });

  setUp(() {
    mockOpenWeatherApiClient = MockOpenWeatherApiClient();
    weatherRepository = WeatherRepository(
      apiKey: 'test_api_key',
      apiClient: mockOpenWeatherApiClient,
    );
  });

  group('WeatherRepository', () {
    test('getWeatherByCity returns WeatherForecast on success', () async {
      final forecastDto = ForecastDto(
        city: _cityDto,
        list: [_mockWeatherDataDto],
      );

      when(() => mockOpenWeatherApiClient.locationSearch(any()))
          .thenAnswer((_) async => _cityDto.coord);
      when(() => mockOpenWeatherApiClient.getWeather(any()))
          .thenAnswer((_) async => forecastDto);

      final result = await weatherRepository.getWeatherByCity('Test City');

      expect(result.location.name, 'Test City');
      expect(result.list, isNotEmpty);
    });

    test(
        'getWeatherByCity throws LocationNotFoundException on location search failure',
        () async {
      when(() => mockOpenWeatherApiClient.locationSearch(any()))
          .thenThrow(LocationNotFoundFailure());

      expect(
        () async => await weatherRepository.getWeatherByCity('Unknown City'),
        throwsA(isA<LocationNotFoundException>()),
      );
    });

    test('getWeatherByCoord returns WeatherForecast on success', () async {
      final forecastDto = ForecastDto(
        city: _cityDto,
        list: [_mockWeatherDataDto],
      );

      when(() => mockOpenWeatherApiClient.getWeather(any()))
          .thenAnswer((_) async => forecastDto);

      final result = await weatherRepository.getWeatherByCoord(1.0, 1.0);

      expect(result.location.name, 'Test City');
      expect(result.list, isNotEmpty);
    });

    test(
        'getWeatherByCoord throws WeatherNotFoundException on weather not found failure',
        () async {
      when(() => mockOpenWeatherApiClient.getWeather(any()))
          .thenThrow(WeatherNotFoundFailure());

      expect(
        () async => await weatherRepository.getWeatherByCoord(1.0, 1.0),
        throwsA(isA<WeatherNotFoundException>()),
      );
    });

    test(
        'getWeatherByCity throws WeatherRequestFailureException on request failure',
        () async {
      when(() => mockOpenWeatherApiClient.locationSearch(any()))
          .thenThrow(WeatherRequestFailure());

      expect(
        () async => await weatherRepository.getWeatherByCity('Test City'),
        throwsA(isA<WeatherRequestFailureException>()),
      );
    });

    test(
        'getWeatherByCity throws WeatherRequestFailureException on request failure',
        () async {
      when(() => mockOpenWeatherApiClient.locationSearch(any()))
          .thenThrow(WeatherRequestFailure());

      expect(
        () async => await weatherRepository.getWeatherByCity('Test City'),
        throwsA(isA<WeatherRequestFailureException>()),
      );
    });

    test(
        'getWeatherByCity throws WeatherRequestFailureException on request failure',
        () async {
      when(() => mockOpenWeatherApiClient.locationSearch(any()))
          .thenThrow(WeatherRequestFailure());

      expect(
        () async => await weatherRepository.getWeatherByCity('Test City'),
        throwsA(isA<WeatherRequestFailureException>()),
      );
    });

    test(
        'getWeatherByCity throws WeatherRequestFailureException on request failure',
        () async {
      when(() => mockOpenWeatherApiClient.locationSearch(any()))
          .thenThrow(WeatherRequestFailure());

      expect(
        () async => await weatherRepository.getWeatherByCity('Test City'),
        throwsA(isA<WeatherRequestFailureException>()),
      );
    });

    test(
        'getWeatherByCity throws WeatherRequestFailureException on request failure',
        () async {
      when(() => mockOpenWeatherApiClient.locationSearch(any()))
          .thenThrow(WeatherRequestFailure());

      expect(
        () async => await weatherRepository.getWeatherByCity('Test City'),
        throwsA(isA<WeatherRequestFailureException>()),
      );
    });
  });
}

final _cityDto = CityDto(
  name: 'Test City',
  coord: CoordDto(lat: 10.1, lon: 2.5),
  country: 'Test Country',
);

final _mockWeatherDataDto = WeatherDataDto(
  main: MainDataDto(
    temp: 25.0,
    pressure: 1013,
    humidity: 60,
  ),
  weather: [
    WeatherDto(
      main: 'Clear',
      description: 'clear sky',
      icon: '01d',
    ),
  ],
  wind: WindDto(
    speed: 5.0,
  ),
  dtTxt: '2021-08-27 12:00:00',
);
