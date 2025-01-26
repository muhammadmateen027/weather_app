import 'package:dio/dio.dart';
import 'package:open_weather_api/open_weather_api.dart';

import 'config/api_config.dart';

class OpenWeatherApiClient {
  OpenWeatherApiClient(this.apiKey, {Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  final Dio _dio;
  final String apiKey;

  /// Searches for locations matching the given query.
  ///
  /// Returns a [LocationDto] for the first matching location.
  ///
  /// Throws a [WeatherRequestFailure] if the request fails.
  ///
  /// Throws a [LocationNotFoundFailure] if no location matches the query.

  Future<LocationDto> locationSearch(String query) async {
    try {
      final response = await _dio.get(
        '/geo/1.0/direct',
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

      return LocationDto.fromJson(results.first);
    } on DioException {
      throw WeatherRequestFailure();
    }
  }

  /// Retrieves a weather forecast for the specified location.
  ///
  /// This function makes a network request to the OpenWeather API to fetch
  /// a weather forecast for the provided [location]. It returns a list of
  /// [WeatherDto] objects representing the forecast data.
  ///
  /// Throws a [WeatherRequestFailure] if the network request fails.
  /// Throws a [WeatherNotFoundFailure] if no weather data is found for the
  /// given location.
  ///
  /// [location]: A [LocationDto] object containing the latitude and longitude
  /// of the desired location.
  ///
  /// Returns a [Future] containing a list of [WeatherDto] objects.

  Future<List<WeatherDto>> getWeather(LocationDto location) async {
    try {
      final response = await _dio.get(
        '/data/2.5/forecast',
        queryParameters: {
          'lat': location.lat,
          'lon': location.lon,
          'appid': apiKey,
          'units': ApiConfig.units,
        },
      );

      if (response.statusCode != 200) {
        throw WeatherRequestFailure();
      }

      final results = response.data['list'] as List;
      if (results.isEmpty) {
        throw WeatherNotFoundFailure();
      }

      return results.map((data) => WeatherDto.fromJson(data)).toList();
    } on DioException {
      throw WeatherRequestFailure();
    }
  }
}
