import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubits/cubits.dart';
import 'package:weather_app/models/models.dart';

import '../../pages.dart';
import '../components/components.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: _AppbarTitle(),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push<void>(
              SettingsPage.route(),
            ),
          ),
        ],
      ),
      body: Center(
        child: BlocBuilder<WeatherCubit, WeatherState>(
          builder: (context, state) {
            return switch (state.dataState) {
              DataState.initial => const WeatherEmpty(),
              DataState.loading => const WeatherLoading(),
              DataState.failure => const WeatherError(),
              DataState.success => WeatherPopulated(
                  weather: state.selectedWeather!,
                  location: state.location!,
                  units: state.temperatureUnit,
                  onRefresh: () {
                    return context.read<WeatherCubit>().refreshWeather();
                  },
                ),
            };
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search, semanticLabel: 'Search'),
        onPressed: () async {
          Navigator.of(context).push(SearchPage.route());
        },
      ),
    );
  }
}

class _AppbarTitle extends StatelessWidget {
  const _AppbarTitle();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      buildWhen: (previous, current) =>
          previous.selectedWeather != current.selectedWeather,
      builder: (context, state) {
        return Text(state.selectedWeather?.date.fullDayName ?? '');
      },
    );
  }
}
