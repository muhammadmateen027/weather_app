import 'package:dio/dio.dart';
import 'package:open_weather_api/open_weather_api.dart';
import 'package:open_weather_api/src/models/forecast_dto.dart';

import 'config/api_config.dart';

/// [OpenWeatherApiClient] for interacting with the OpenWeather API.
///
/// This client provides methods to search for locations and retrieve weather forecasts
/// using the OpenWeather API. It uses the Dio package for making HTTP requests and
/// handles various exceptions that may occur during the requests.
class OpenWeatherApiClient {
  OpenWeatherApiClient(this.apiKey, {Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConfig.baseUrl))
          ..interceptors.add(LogInterceptor(responseBody: true));

  final Dio _dio;
  final String apiKey;

  /// Searches for a location with the given [query].
  ///
  /// Throws a [WeatherRequestFailure] if the request fails.
  /// Throws a [LocationNotFoundFailure] if no location is found.
  ///
  /// Returns a [CoordDto] containing the coordinates of the location.
  Future<CoordDto> locationSearch(String query) async {
    try {
      final response = await _dio.get(
        '${ApiConfig.geoPath}/direct',
        queryParameters: {
          'q': query,
          'limit': ApiConfig.limit,
          'appid': apiKey,
        },
      );

      if (response.statusCode != 200) {
        throw WeatherRequestFailure();
      }

      final List<dynamic> results = response.data;
      if (results.isEmpty) {
        throw LocationNotFoundFailure();
      }

      return CoordDto.fromJson(results.first);
    } on DioException {
      throw WeatherRequestFailure();
    }
  }

  /// Retrieves the forecast for the given coordinate.
  ///
  /// Returns a [ForecastDto] with the current weather and a 5 day forecast.
  ///
  /// Throws a [WeatherRequestFailure] if the request fails.
  Future<ForecastDto> getWeather(CoordDto coord) async {
    try {
      final response = await _dio.get(
        '${ApiConfig.weatherPath}/forecast',
        queryParameters: {
          'lat': coord.lat,
          'lon': coord.lon,
          'appid': apiKey,
          'units': ApiConfig.units,
        },
      );

      if (response.statusCode != 200) {
        throw WeatherRequestFailure();
      }

      return ForecastDto.fromJson(response.data);
    } on DioException {
      throw WeatherRequestFailure();
    }
  }
}
