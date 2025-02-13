import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/app/app.dart';
import 'package:weather_app/cubits/weather/weather_cubit.dart';
import 'package:weather_repository/weather_repository.dart';

class WidgetTestbed {
  WidgetTestbed();

  Widget simpleWrap({
    final Widget? child,
    final RouteFactory? routeFactory,
    final Brightness brightness = Brightness.light,
  }) {
    return MaterialApp(
      theme: ThemeData(brightness: brightness),
      onGenerateRoute: routeFactory,
      home: child != null ? Material(child: child) : null,
    );
  }

  Widget blocWrap({
    required final Widget child,
    required final WeatherCubit cubit,
  }) {
    return _blocWrap(
      cubit: cubit,
      child: simpleWrap(
        child: child,
      ),
    );
  }

  Widget _blocWrap({
    required final Widget child,
    required WeatherCubit cubit,
  }) {
    return BlocProvider.value(
      value: cubit,
      child: child,
    );
  }

  Widget pumpAppWithRepo({
    required final WeatherRepository repository,
  }) {
    return WeatherApp(weatherRepository: repository);
  }
}
