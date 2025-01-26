part of 'weather_cubit.dart';

class WeatherState extends Equatable {
  const WeatherState({
    required this.dataState,
    this.selectedWeather,
    this.location,
    this.error,
    this.temperatureUnit = TemperatureUnit.celsius,
  });

  final DataState dataState;
  final DisplayWeather? selectedWeather;
  final String? error;
  final Location? location;
  final TemperatureUnit temperatureUnit;

  factory WeatherState.initial() {
    return WeatherState(dataState: DataState.initial);
  }

  WeatherState copyWith({
    DataState? dataState,
    DisplayWeather? selectedWeather,
    Location? location,
    String? error,
    TemperatureUnit? temperatureUnit,
  }) {
    return WeatherState(
      dataState: dataState ?? this.dataState,
      selectedWeather: selectedWeather ?? this.selectedWeather,
      location: location ?? this.location,
      error: error ?? this.error,
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
    );
  }

  @override
  List<Object?> get props => [
        dataState,
        selectedWeather,
        location,
        error,
        temperatureUnit,
      ];
}
