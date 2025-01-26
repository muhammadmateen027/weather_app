import 'package:open_weather_api/open_weather_api.dart' as api;
import 'package:weather_repository/weather_repository.dart';

/// [WeatherRepository] that provides weather data by interacting with
/// the OpenWeather API.
///
/// The `WeatherRepository` class is responsible for fetching weather data for a given city
/// or geographic coordinates. It uses the `OpenWeatherApiClient` to perform the necessary
/// API calls and handles any exceptions that may occur during the process.
class WeatherRepository {
  /// Creates a new instance of `WeatherRepository`.
  ///
  /// The [apiKey] is required to authenticate with the OpenWeather API.
  WeatherRepository({required String apiKey})
      : _weatherApiClient = api.OpenWeatherApiClient(apiKey);

  final api.OpenWeatherApiClient _weatherApiClient;

  /// Retrieves the weather forecast for a given city.
  ///
  /// Performs a location search using the provided [city] name to obtain the
  /// coordinates, and then fetches the weather forecast for those coordinates.
  ///
  /// Throws a [LocationNotFoundException] if the city cannot be found.
  ///
  /// Returns a [WeatherForecast] containing the weather data for the specified city.
  Future<WeatherForecast> getWeatherByCity(String city) async {
    try {
      final coordinates = await _weatherApiClient.locationSearch(city);
      return await _getWeatherForecast(coordinates);
    } on api.LocationNotFoundFailure {
      throw LocationNotFoundException();
    }
  }

  /// Retrieves the weather forecast for the given latitude and longitude.
  ///
  /// Takes [lat] and [lon] as the geographic coordinates for which to retrieve
  /// the forecast.
  ///
  /// Returns a [WeatherForecast] containing the current weather and a 5-day
  /// forecast for the specified location.
  ///
  /// Throws a [WeatherNotFoundException] if no weather data is found.
  /// Throws a [WeatherRequestFailureException] if the request fails.
  Future<WeatherForecast> getWeatherByCoord(double lat, double lon) async {
    return await _getWeatherForecast(api.CoordDto(lat: lat, lon: lon));
  }

  /// Given a [api.CoordDto], retrieve a [WeatherForecast] containing the
  /// weather forecast for the given coordinates.
  ///
  /// If the coordinates are invalid, throw a [LocationNotFoundException].
  ///
  /// If the request fails, throw a [WeatherRequestFailureException].
  ///
  /// If the weather is not found at the given coordinates, throw a
  /// [WeatherNotFoundException].
  ///
  Future<WeatherForecast> _getWeatherForecast(api.CoordDto coordinates) async {
    try {
      final forecastDto = await _weatherApiClient.getWeather(coordinates);

      return WeatherForecast(
        location: Location.fromDto(forecastDto.city),
        list: forecastDto.list.map((e) => WeatherData.fromDto(e)).toList(),
      );
    } on api.WeatherNotFoundFailure {
      throw WeatherNotFoundException();
    } on api.WeatherRequestFailure {
      throw WeatherRequestFailureException();
    }
  }
}
