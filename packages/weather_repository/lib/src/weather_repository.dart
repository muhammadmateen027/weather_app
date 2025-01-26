import 'package:open_weather_api/open_weather_api.dart' as api;
import 'package:weather_repository/weather_repository.dart';

class WeatherRepository {
  WeatherRepository({required String apiKey})
      : _weatherApiClient = api.OpenWeatherApiClient(apiKey);

  final api.OpenWeatherApiClient _weatherApiClient;

  /// Returns a list of [Weather] objects for a given city.
  ///
  /// Throws a [LocationNotFoundException] if the city could not be found.
  /// Throws a [WeatherNotFoundException] if the weather for the city could
  /// not be found.
  /// Throws a [WeatherRequestFailureException] if the request to the API fails.
  ///
  /// This method will throw a [LocationNotFoundException] if the
  /// [city] argument is empty.

  Future<List<Weather>> getWeatherByCity(String city) async {
    try {
      final location = await _weatherApiClient.locationSearch(city);
      final weatherList = await _weatherApiClient.getWeather(location);

      return weatherList.map((weather) => weather.toDomain()).toList();
    } on api.LocationNotFoundFailure {
      throw LocationNotFoundException();
    } on api.WeatherNotFoundFailure {
      throw WeatherNotFoundException();
    } on api.WeatherRequestFailure {
      throw WeatherRequestFailureException();
    }
  }
}

extension _WeatherX on api.WeatherDto {
  Weather toDomain() {
    return Weather(
      condition: weather.first.main,
      description: weather.first.description,
      iconCode: weather.first.icon,
      temperature: main.temp,
      pressure: main.pressure,
      humidity: main.humidity,
      windSpeed: wind.speed,
      date: date,
    );
  }
}
