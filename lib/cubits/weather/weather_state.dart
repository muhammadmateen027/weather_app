part of 'weather_cubit.dart';

class WeatherState extends Equatable {
  const WeatherState({
    required this.dataState,
    this.selectedWeather,
    this.location,
    this.error,
    this.temperatureUnits = TemperatureUnit.celsius,
  });

  final DataState dataState;
  final DisplayWeather? selectedWeather;
  final String? error;
  final Location? location;
  final TemperatureUnit temperatureUnits;

  factory WeatherState.initial() {
    return WeatherState(dataState: DataState.initial);
  }

  WeatherState copyWith({
    DataState? dataState,
    DisplayWeather? selectedWeather,
    Location? location,
    String? error,
    TemperatureUnit? temperatureUnits,
  }) {
    return WeatherState(
      dataState: dataState ?? this.dataState,
      selectedWeather: selectedWeather ?? this.selectedWeather,
      location: location ?? this.location,
      error: error ?? this.error,
      temperatureUnits: temperatureUnits ?? this.temperatureUnits,
    );
  }

  @override
  List<Object?> get props => [
        dataState,
        selectedWeather,
        location,
        error,
        temperatureUnits,
      ];
}
