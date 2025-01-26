import 'package:equatable/equatable.dart';
import 'package:open_weather_api/open_weather_api.dart';
import 'package:weather_repository/src/models/models.dart';

class WeatherForecast extends Equatable {
  const WeatherForecast({
    required this.list,
    required this.location,
  });

  final List<WeatherData> list;
  final Location location;

  @override
  List<Object?> get props => [list, location];
}

class WeatherData extends Equatable {
  const WeatherData({
    required this.condition,
    required this.description,
    required this.iconCode,
    required this.temperature,
    required this.pressure,
    required this.humidity,
    required this.windSpeed,
    required this.date,
  });

  factory WeatherData.fromDto(WeatherDataDto dto) {
    return WeatherData(
      temperature: dto.main.temp,
      pressure: dto.main.pressure,
      humidity: dto.main.humidity,
      windSpeed: dto.wind.speed,
      condition: dto.weather.first.main,
      description: dto.weather.first.description,
      iconCode: dto.weather.first.icon,
      date: DateTime.parse(dto.dtTxt),
    );
  }

  final double temperature;
  final int pressure;
  final int humidity;
  final double windSpeed;
  final String condition;
  final String description;
  final String iconCode;
  final DateTime date;

  @override
  List<Object?> get props => [
        temperature,
        pressure,
        humidity,
        windSpeed,
        condition,
        description,
        iconCode,
        date,
      ];
}
