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
    emit(state.copyWith(dataState: DataState.loading, error: null));

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
    } on LocationNotFoundException {
      _emitErrorState('City not found');
    } on WeatherNotFoundException {
      _emitErrorState('Weather not found');
    } on WeatherRequestFailureException {
      _emitErrorState('Failed to fetch weather');
    }
  }

  void selectWeather(DisplayWeather newSelection) {
    emit(state.copyWith(selectedWeather: newSelection));
  }

  Future<void> refreshWeather() async {
    if (state.location == null) {
      return;
    }

    emit(state.copyWith(dataState: DataState.loading, error: null));

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
    } on WeatherNotFoundException {
      _emitErrorState('Weather not found');
    } on WeatherRequestFailureException {
      _emitErrorState('Failed to refresh weather');
    }
  }

  void _emitErrorState(String error) {
    emit(state.copyWith(dataState: DataState.failure, error: error));
  }

  void toggleTemperatureUnit() {
    final newUnit = state.temperatureUnit.isCelsius
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
