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
      (type) => type.name.toLowerCase().contains(input.toLowerCase()),
      orElse: () => WeatherCondition.clear,
    );
  }

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

  String get name {
    switch (this) {
      case WeatherCondition.clear:
        return 'Clear Sky';
      case WeatherCondition.clouds:
        return 'Cloudy';
      case WeatherCondition.rain:
        return 'Rainy';
      case WeatherCondition.drizzle:
        return 'Light Rain';
      case WeatherCondition.thunderstorm:
        return 'Thunderstorm';
      case WeatherCondition.snow:
        return 'Snowy';
      case WeatherCondition.mist:
        return 'Misty';
      case WeatherCondition.smoke:
        return 'Smoky';
      case WeatherCondition.haze:
        return 'Hazy';
      case WeatherCondition.dust:
        return 'Dusty';
      case WeatherCondition.fog:
        return 'Foggy';
      case WeatherCondition.sand:
        return 'Sandy';
      case WeatherCondition.ash:
        return 'Volcanic Ash';
      case WeatherCondition.squall:
        return 'Squall';
      case WeatherCondition.tornado:
        return 'Tornado';
    }
  }
}

class DisplayWeather extends Equatable {
  const DisplayWeather({
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

  final String description;
  final String iconCode;
  final double temperature;
  final int pressure;
  final int humidity;
  final double windSpeed;
  final DateTime date;
  final WeatherCondition weatherCondition;
  final TemperatureUnit unit;

  factory DisplayWeather.fromRepository(WeatherData weather) {
    return DisplayWeather(
      description: weather.description,
      iconCode: weather.iconCode,
      temperature: weather.temperature,
      pressure: weather.pressure,
      humidity: weather.humidity,
      windSpeed: weather.windSpeed,
      date: weather.date,
      unit: TemperatureUnit.celsius,
      weatherCondition: WeatherCondition.fromString(weather.condition),
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
      weatherCondition: weatherCondition,
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

  String get shortDayName => fullDayName.substring(0, 3);

  String get formattedTime {
    final hour = this.hour > 12 ? this.hour - 12 : this.hour;
    final adjustedHour = hour == 0 ? 12 : hour;
    final minute = this.minute.toString().padLeft(2, '0');
    final period = this.hour >= 12 ? 'PM' : 'AM';

    return '$adjustedHour:$minute $period';
  }
}
