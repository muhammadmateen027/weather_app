import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubits/cubits.dart';
import 'package:weather_app/models/display_weather.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SettingsPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: <Widget>[
          BlocBuilder<WeatherCubit, WeatherState>(
            buildWhen: (previous, current) =>
                previous.temperatureUnit != current.temperatureUnit,
            builder: (context, state) {
              return ListTile(
                title: const Text('Temperature Units'),
                isThreeLine: true,
                subtitle: const Text(
                  'Use metric measurements for temperature units.',
                ),
                trailing: Switch(
                  value: state.temperatureUnit.isCelsius,
                  onChanged: (_) =>
                      context.read<WeatherCubit>().toggleTemperatureUnit(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
