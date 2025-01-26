import 'dart:developer';

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
      log('WeatherForecast: $weathers');
      emit(
        state.copyWith(
          dataState: DataState.success,
          location: weathers.location,
          selectedWeather: DisplayWeather.fromRepository(
            weathers.list.first,
            state.temperatureUnits,
          ),
        ),
      );

      // final weather = DisplayWeather.fromRepository(
      //   await _weatherRepository.getWeatherByCity(city),
      // );
      //
      // final units = state.temperatureUnits;
      // final value = units.isFahrenheit
      //     ? weather.temperature.value.toFahrenheit()
      //     : weather.temperature.value;
      //
      // emit(
      //   state.copyWith(
      //     dataState: DataState.success,
      //     temperatureUnits: units,
      //     weather: weather.copyWith(temperature: Temperature(value: value)),
      //   ),
      // );
    } on Exception {
      emit(state.copyWith(dataState: DataState.failure));
    }
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
            state.temperatureUnits,
          ),
        ),
      );
    } on Exception {
      emit(state.copyWith(dataState: DataState.failure));
    }
  }
}
