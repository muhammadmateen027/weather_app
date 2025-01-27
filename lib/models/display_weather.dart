import 'package:equatable/equatable.dart';
import 'package:weather_repository/weather_repository.dart';

part 'temperature_unit.dart';
part 'weather_condition.dart';

class DisplayWeather extends Equatable {
  const DisplayWeather({
    required this.description,
    required this.iconCode,
    required this.temperature,
    required this.pressure,
    required this.humidity,
    required this.windSpeed,
    required this.date,
    required this.condition,
    this.unit = TemperatureUnit.celsius,
  });

  final String description;
  final String iconCode;
  final double temperature;
  final int pressure;
  final int humidity;
  final double windSpeed;
  final DateTime date;
  final WeatherCondition condition;
  final TemperatureUnit unit;

  factory DisplayWeather.fromRepository(
      WeatherData weather, TemperatureUnit unit) {
    return DisplayWeather(
      description: weather.description,
      iconCode: weather.iconCode,
      temperature: unit == TemperatureUnit.celsius
          ? weather.temperature
          : (weather.temperature * 9 / 5) + 32,
      pressure: weather.pressure,
      humidity: weather.humidity,
      windSpeed: weather.windSpeed,
      date: weather.date,
      unit: unit,
      condition: WeatherCondition.fromString(weather.condition),
    );
  }

  DisplayWeather copyWith({TemperatureUnit? unit}) {
    return DisplayWeather(
      description: description,
      iconCode: iconCode,
      temperature: temperature,
      pressure: pressure,
      humidity: humidity,
      windSpeed: windSpeed,
      date: date,
      unit: unit ?? this.unit,
      condition: condition,
    );
  }

  double get _displayTemperature => unit == TemperatureUnit.celsius
      ? temperature
      : (temperature * 9 / 5) + 32;

  String get formattedTemperature =>
      '${_displayTemperature.toStringAsFixed(3)}°${unit == TemperatureUnit.celsius ? 'C' : 'F'}';

  @override
  List<Object> get props => [
        description,
        iconCode,
        temperature,
        pressure,
        humidity,
        windSpeed,
        date,
        unit,
        condition,
      ];
}
