part of 'display_weather.dart';

enum TemperatureUnit { celsius, fahrenheit }

extension TemperatureUnitsX on TemperatureUnit {
  bool get isFahrenheit => this == TemperatureUnit.fahrenheit;

  bool get isCelsius => this == TemperatureUnit.celsius;
}
