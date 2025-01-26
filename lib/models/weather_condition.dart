part of 'display_weather.dart';

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
