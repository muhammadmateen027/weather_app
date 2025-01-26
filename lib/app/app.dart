import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubits/cubits.dart';
import 'package:weather_app/models/models.dart';
import 'package:weather_repository/weather_repository.dart';

import '../pages/pages.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({required WeatherRepository weatherRepository, super.key})
      : _weatherRepository = weatherRepository;

  final WeatherRepository _weatherRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WeatherCubit(_weatherRepository),
      child: const WeatherAppView(),
    );
  }
}

class WeatherAppView extends StatelessWidget {
  const WeatherAppView({super.key});

  @override
  Widget build(BuildContext context) {
    final seedColor = context.select(
      (WeatherCubit cubit) => cubit.state.selectedWeather?.condition.color,
    );
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor ?? Colors.blue),
      ),
      home: const WeatherPage(),
    );
  }
}

extension _WeatherConditionX on WeatherCondition {
  Color get color {
    switch (this) {
      case WeatherCondition.clear:
        return Colors.orange;
      case WeatherCondition.clouds:
        return Colors.blueGrey;
      case WeatherCondition.rain:
        return Colors.indigo;
      case WeatherCondition.drizzle:
        return Colors.lightBlue;
      case WeatherCondition.thunderstorm:
        return Colors.deepPurple;
      case WeatherCondition.snow:
        return Colors.lightBlueAccent;
      case WeatherCondition.mist:
        return Colors.grey;
      case WeatherCondition.smoke:
        return Colors.grey.shade700;
      case WeatherCondition.haze:
        return Colors.brown.shade200;
      case WeatherCondition.dust:
        return Colors.brown;
      case WeatherCondition.fog:
        return Colors.blueGrey.shade200;
      case WeatherCondition.sand:
        return Colors.orange.shade300;
      case WeatherCondition.ash:
        return Colors.grey.shade800;
      case WeatherCondition.squall:
        return Colors.blueGrey.shade700;
      case WeatherCondition.tornado:
        return Colors.red.shade900;
    }
  }
}
