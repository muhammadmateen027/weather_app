import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_repository/weather_repository.dart';

import '../../models/models.dart';

part 'data_state.dart';
part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit(this._weatherRepository) : super(WeatherState.initial());

  final WeatherRepository _weatherRepository;

  Future<void> fetchWeather(String? city) async {
    if (city == null || city.isEmpty) {
      return;
    }
    emit(state.copyWith(dataState: DataState.loading));

    try {
      final weathers = await _weatherRepository.getWeatherByCity(city);
      final selectedWeather = DisplayWeather.fromRepository(
        weathers.list.first,
        state.temperatureUnit,
      );

      final List<DisplayWeather> forecast = weathers.list
          .map((weather) =>
              DisplayWeather.fromRepository(weather, state.temperatureUnit))
          .toList();

      emit(
        state.copyWith(
          dataState: DataState.success,
          location: weathers.location,
          selectedWeather: selectedWeather,
          forecast: forecast,
        ),
      );
    } on Exception {
      emit(state.copyWith(dataState: DataState.failure));
    }
  }

  List<DisplayWeather> _reorderWeathers(DisplayWeather newSelection) {
    final previousSelection = state.selectedWeather;
    final List<DisplayWeather> orderedList = [...state.forecast];

    // First, if there was a previous selection, insert it back in chronological order
    if (previousSelection != null) {
      int insertIndex = orderedList.indexWhere(
          (weather) => weather.date.isAfter(previousSelection.date));
      if (insertIndex == -1) {
        orderedList.add(previousSelection);
      } else {
        orderedList.insert(insertIndex, previousSelection);
      }
    }

    // Then remove the newly selected weather from the list
    orderedList.removeWhere((weather) => weather == newSelection);

    return orderedList;
  }

  void selectWeather(DisplayWeather newSelection) {
    emit(state.copyWith(selectedWeather: newSelection));
  }

  Future<void> refreshWeather() async {
    if (state.location == null) {
      return;
    }
    await _refreshCityWeather();
  }

  Future<void> _refreshCityWeather() async {
    emit(state.copyWith(dataState: DataState.loading));

    try {
      final weathers = await _weatherRepository.getWeatherByCoord(
        state.location!.latitude,
        state.location!.longitude,
      );

      emit(
        state.copyWith(
          dataState: DataState.success,
          location: weathers.location,
          selectedWeather: DisplayWeather.fromRepository(
            weathers.list.first,
            state.temperatureUnit,
          ),
        ),
      );
    } on Exception {
      emit(state.copyWith(dataState: DataState.failure));
    }
  }

  void toggleTemperatureUnit() {
    final newUnit = state.temperatureUnit == TemperatureUnit.celsius
        ? TemperatureUnit.fahrenheit
        : TemperatureUnit.celsius;

    emit(
      state.copyWith(
        temperatureUnit: newUnit,
        selectedWeather: state.selectedWeather?.copyWith(unit: newUnit),
        forecast: state.forecast
            .map((forecast) => forecast.copyWith(unit: newUnit))
            .toList(),
      ),
    );
  }
}
