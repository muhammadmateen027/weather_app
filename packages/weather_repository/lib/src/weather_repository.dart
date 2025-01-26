import 'package:open_weather_api/open_weather_api.dart' as api;
import 'package:weather_repository/weather_repository.dart';

class WeatherRepository {
  WeatherRepository({required String apiKey})
      : _weatherApiClient = api.OpenWeatherApiClient(apiKey);

  final api.OpenWeatherApiClient _weatherApiClient;

  Future<WeatherForecast> getWeatherByCity(String city) async {
    try {
      final coordinates = await _weatherApiClient.locationSearch(city);
      return await _getWeatherForecast(coordinates);
    } on api.LocationNotFoundFailure {
      throw LocationNotFoundException();
    }
  }

  Future<WeatherForecast> getWeatherByCoord(double lat, double lon) async {
    return await _getWeatherForecast(api.CoordDto(lat: lat, lon: lon));
  }

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
