import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:open_weather_api/open_weather_api.dart';
import 'package:test/test.dart';

class MockDio extends Mock implements Dio {
  @override
  final Interceptors interceptors = Interceptors();
}

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  group('OpenWeatherApiClient', () {
    late OpenWeatherApiClient apiClient;
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      apiClient = OpenWeatherApiClient('test_api_key', dio: mockDio);
    });

    group('locationSearch', () {
      test('returns CoordDto when the location is found', () async {
        final response = Response(
          data: [
            {'lat': 1.0, 'lon': 2.0}
          ],
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        when(
          () => mockDio.get(any(),
              queryParameters: any(named: 'queryParameters')),
        ).thenAnswer((_) async => response);

        final result = await apiClient.locationSearch('test');

        expect(result, isA<CoordDto>());
        expect(result.lat, 1.0);
        expect(result.lon, 2.0);
      });

      test('throws LocationNotFoundFailure when no location is found',
          () async {
        final response = Response(
          data: [],
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        when(() => mockDio.get(any(),
                queryParameters: any(named: 'queryParameters')))
            .thenAnswer((_) async => response);

        expect(
          () async => await apiClient.locationSearch('test'),
          throwsA(isA<LocationNotFoundFailure>()),
        );
      });

      test('throws WeatherRequestFailure when the request fails', () async {
        when(() => mockDio.get(any(),
                queryParameters: any(named: 'queryParameters')))
            .thenThrow(DioException(requestOptions: RequestOptions(path: '')));

        expect(
          () async => await apiClient.locationSearch('test'),
          throwsA(isA<WeatherRequestFailure>()),
        );
      });

      test('throws WeatherRequestFailure when the response code is not 200',
          () async {
        final response = Response(
          data: [],
          statusCode: 400,
          requestOptions: RequestOptions(path: ''),
        );

        when(() => mockDio.get(any(),
                queryParameters: any(named: 'queryParameters')))
            .thenAnswer((_) async => response);

        expect(
          () async => await apiClient.locationSearch('test'),
          throwsA(isA<WeatherRequestFailure>()),
        );
      });
    });

    group('getWeather', () {
      test('returns ForecastDto when the request is successful', () async {
        final response = Response(
          data: {
            'city': _cityJson,
            'list': [_forecastJson]
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        when(() => mockDio.get(any(),
                queryParameters: any(named: 'queryParameters')))
            .thenAnswer((_) async => response);

        final result = await apiClient.getWeather(CoordDto(lat: 1.0, lon: 2.0));

        expect(result, isA<ForecastDto>());
        expect(result.city.name, 'Test City');
      });

      test('throws WeatherRequestFailure when the request fails', () async {
        when(() => mockDio.get(any(),
                queryParameters: any(named: 'queryParameters')))
            .thenThrow(DioException(requestOptions: RequestOptions(path: '')));

        expect(
          () async => await apiClient.getWeather(CoordDto(lat: 1.0, lon: 2.0)),
          throwsA(isA<WeatherRequestFailure>()),
        );
      });

      test('throws WeatherRequestFailure when the status code is not 200',
          () async {
        final response = Response(
          data: [
            {'lat': 1.0, 'lon': 2.0}
          ],
          statusCode: 400,
          requestOptions: RequestOptions(path: ''),
        );

        when(() => mockDio.get(any(),
                queryParameters: any(named: 'queryParameters')))
            .thenAnswer((_) async => response);

        expect(
          () async => await apiClient.getWeather(CoordDto(lat: 1.0, lon: 2.0)),
          throwsA(isA<WeatherRequestFailure>()),
        );
      });
    });
  });
}

final _cityJson = <String, dynamic>{
  'id': 1,
  'name': 'Test City',
  'coord': {'lat': 1.0, 'lon': 2.0},
  'country': 'Test Country',
  'population': 1000,
  'timezone': 3600,
  'sunrise': 1633065600,
  'sunset': 1633108800
};

final _forecastJson = <String, dynamic>{
  'dt': 1633036800,
  'main': {
    'temp': 298.55,
    'feels_like': 298.95,
    'temp_min': 297.15,
    'temp_max': 299.82,
    'pressure': 1013,
    'humidity': 83
  },
  'weather': [
    {'id': 800, 'main': 'Clear', 'description': 'clear sky', 'icon': '01d'}
  ],
  'clouds': {'all': 0},
  'wind': {'speed': 1.5, 'deg': 350},
  'visibility': 10000,
  'pop': 0,
  'sys': {'pod': 'd'},
  'dt_txt': '2021-10-01 00:00:00'
};
