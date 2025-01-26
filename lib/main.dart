import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/weather_bloc_observer.dart';
import 'package:weather_repository/weather_repository.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const WeatherBlocObserver();
  final apiKey = const String.fromEnvironment('OPEN_WEATHER_API_KEY');

  // TODO: If key is not provided, show an error message

  runApp(WeatherApp(weatherRepository: WeatherRepository(apiKey: apiKey)));
}
