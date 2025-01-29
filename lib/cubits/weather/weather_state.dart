part of 'weather_cubit.dart';

class WeatherState extends Equatable {
  const WeatherState({
    required this.dataState,
    this.selectedWeather,
    this.forecast = const [],
    this.location,
    this.error,
    this.temperatureUnit = TemperatureUnit.celsius,
    this.searchedCityName = '',
  });

  final DataState dataState;
  final DisplayWeather? selectedWeather;
  final List<DisplayWeather> forecast;
  final String? error;
  final Location? location;
  final TemperatureUnit temperatureUnit;
  final String searchedCityName;

  factory WeatherState.initial() {
    return WeatherState(dataState: DataState.initial);
  }

  WeatherState copyWith({
    DataState? dataState,
    DisplayWeather? selectedWeather,
    List<DisplayWeather>? forecast,
    Location? location,
    String? error,
    TemperatureUnit? temperatureUnit,
    String? searchedCityName,
  }) {
    return WeatherState(
      dataState: dataState ?? this.dataState,
      selectedWeather: selectedWeather ?? this.selectedWeather,
      forecast: forecast ?? this.forecast,
      location: location ?? this.location,
      error: error ?? this.error,
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      searchedCityName: searchedCityName ?? this.searchedCityName,
    );
  }

  @override
  List<Object?> get props => [
        dataState,
        selectedWeather,
        forecast,
        location,
        error,
        temperatureUnit,
        searchedCityName,
      ];
}
