import 'package:equatable/equatable.dart';
import 'package:weather_repository/weather_repository.dart';

enum TemperatureUnit { celsius, fahrenheit }

extension TemperatureUnitsX on TemperatureUnit {
  bool get isFahrenheit => this == TemperatureUnit.fahrenheit;

  bool get isCelsius => this == TemperatureUnit.celsius;
}

enum WeatherCondition {
  clear,
  clouds,
  rain,
  drizzle,
  thunderstorm,
  snow,
  mist,
  smoke,
  haze,
  dust,
  fog,
  sand,
  ash,
  squall,
  tornado;

  factory WeatherCondition.fromString(String input) {
    return WeatherCondition.values.firstWhere(
      (type) => type.name.toLowerCase() == input.toLowerCase(),
      orElse: () => WeatherCondition.clear,
    );
  }
}

class DisplayWeather extends Equatable {
  const DisplayWeather({
    required this.condition,
    required this.description,
    required this.iconCode,
    required this.temperature,
    required this.pressure,
    required this.humidity,
    required this.windSpeed,
    required this.date,
    required this.weatherCondition,
    this.unit = TemperatureUnit.celsius,
  });

  final String condition;
  final String description;
  final String iconCode;
  final double temperature;
  final int pressure;
  final int humidity;
  final double windSpeed;
  final DateTime date;
  final WeatherCondition weatherCondition;
  final TemperatureUnit unit;

  factory DisplayWeather.fromRepository(
    WeatherData weather,
    TemperatureUnit unit,
  ) {
    return DisplayWeather(
      condition: weather.condition,
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
      weatherCondition: WeatherCondition.fromString(weather.condition),
    );
  }

  String get formattedTemperature =>
      '${temperature.toStringAsFixed(1)}°${unit == TemperatureUnit.celsius ? 'C' : 'F'}';

  @override
  List<Object> get props => [
        condition,
        description,
        iconCode,
        temperature,
        pressure,
        humidity,
        windSpeed,
        date,
        unit,
        weatherCondition,
      ];
}

extension DateTimeString on DateTime {
  String get fullDayName {
    switch (weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }

  String get shortDayName {
    return fullDayName.substring(0, 3);
  }
}

extension WeatherConditionX on WeatherCondition {
  String get toEmoji {
    switch (this) {
      case WeatherCondition.clear:
        return '☀️';
      case WeatherCondition.clouds:
        return '☁️';
      case WeatherCondition.rain:
        return '🌧️';
      case WeatherCondition.drizzle:
        return '🌦️';
      case WeatherCondition.thunderstorm:
        return '⛈️';
      case WeatherCondition.snow:
        return '🌨️';
      case WeatherCondition.mist:
        return '🌫️';
      case WeatherCondition.smoke:
        return '💨';
      case WeatherCondition.haze:
        return '🌫️';
      case WeatherCondition.dust:
        return '💨';
      case WeatherCondition.fog:
        return '🌫️';
      case WeatherCondition.sand:
        return '💨';
      case WeatherCondition.ash:
        return '💨';
      case WeatherCondition.squall:
        return '💨';
      case WeatherCondition.tornado:
        return '🌪️';
    }
  }
}
