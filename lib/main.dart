import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/weather_bloc_observer.dart';
import 'package:weather_repository/weather_repository.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const WeatherBlocObserver();
  String? apiKey = const String.fromEnvironment('OPEN_WEATHER_API_KEY');

  bool hasNoApiKey = apiKey.trim().isEmpty;

  runApp(
    hasNoApiKey
        ? _EmptyErrorPage()
        : WeatherApp(weatherRepository: WeatherRepository(apiKey: apiKey)),
  );
}

class _EmptyErrorPage extends StatelessWidget {
  const _EmptyErrorPage();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        color: const Color(0xFFFFEBEE),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                SizedBox(height: 16),
                Text(
                  'API Key Not Found',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Please provide the OpenWeather API key using --dart-define=OPEN_WEATHER_API_KEY=your_api_key',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
