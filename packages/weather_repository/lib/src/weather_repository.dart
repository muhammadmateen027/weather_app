import 'package:open_weather_api/open_weather_api.dart' as api;
import 'package:weather_repository/weather_repository.dart';

/// [WeatherRepository] that provides weather data by interacting with
/// the OpenWeather API.
///
/// The [WeatherRepository] class is responsible for fetching weather data for a given city
/// or geographic coordinates. It uses the [OpenWeatherApiClient] to perform the necessary
/// API calls and handles any exceptions that may occur during the process.
class WeatherRepository {
  /// Creates a new instance of [WeatherRepository].
  ///
  /// The [apiKey] is required to authenticate with the OpenWeather API.
  WeatherRepository({required String apiKey})
      : _weatherApiClient = api.OpenWeatherApiClient(apiKey);

  final api.OpenWeatherApiClient _weatherApiClient;

  /// Retrieves the forecast for the given [city].
  ///
  /// Throws a [LocationNotFoundException] if the city is not found.
  /// Throws a [WeatherNotFoundException] if the weather data is not found.
  /// Throws a [WeatherRequestFailureException] if the request fails.
  ///
  /// Returns a [WeatherForecast] with the current weather and a 5 day forecast.
  Future<WeatherForecast> getWeatherByCity(String city) async {
    try {
      final coordinates = await _weatherApiClient.locationSearch(city);
      return await _getWeatherForecast(coordinates);
    } on api.LocationNotFoundFailure {
      throw LocationNotFoundException();
    } on api.WeatherNotFoundFailure {
      throw WeatherNotFoundException();
    } on api.WeatherRequestFailure {
      throw WeatherRequestFailureException();
    }
  }

  /// Retrieves the forecast for the given coordinates.
  ///
  /// Throws a [WeatherNotFoundException] if the weather data is not found.
  /// Throws a [WeatherRequestFailureException] if the request fails.
  ///
  /// Returns a [WeatherForecast] with the current weather and a 5 day forecast.
  Future<WeatherForecast> getWeatherByCoord(double lat, double lon) async {
    try {
      return await _getWeatherForecast(api.CoordDto(lat: lat, lon: lon));
    } on api.WeatherNotFoundFailure {
      throw WeatherNotFoundException();
    } on api.WeatherRequestFailure {
      throw WeatherRequestFailureException();
    }
  }

  /// Retrieves the weather forecast for the specified coordinates.
  ///
  /// This method interacts with the `OpenWeatherApiClient` to fetch the weather
  /// data for the given geographical coordinates and transforms the data into a
  /// `WeatherForecast` object.
  ///
  /// Returns a [WeatherForecast] containing the location and a list of weather
  /// data for the forecast period.
  Future<WeatherForecast> _getWeatherForecast(api.CoordDto coordinates) async {
    final forecastDto = await _weatherApiClient.getWeather(coordinates);
    return WeatherForecast(
      location: Location.fromDto(forecastDto.city),
      list: forecastDto.list.map((e) => WeatherData.fromDto(e)).toList(),
    );
  }
}
