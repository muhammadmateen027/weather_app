import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubits/cubits.dart';
import 'package:weather_app/utils/utils.dart';

import '../../pages.dart';
import '../components/components.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedWeather = context.select(
      (WeatherCubit cubit) => cubit.state.selectedWeather,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: _AppbarTitle(),
        centerTitle: true,
        actions: selectedWeather == null ? [] : [_SettingIcon()],
      ),
      body: Center(
        child: BlocBuilder<WeatherCubit, WeatherState>(
          builder: (context, state) {
            return switch (state.dataState) {
              DataState.initial => const WeatherEmpty(),
              DataState.loading => const WeatherLoading(),
              DataState.failure => WeatherError(errorMessage: state.error),
              DataState.success => WeatherPopulated(
                  weather: state.selectedWeather!,
                  location: state.location!,
                  forecasts: state.forecast,
                  onRefresh: () {
                    return context.read<WeatherCubit>().refreshWeather();
                  },
                  onCardTapped: (weather) {
                    context.read<WeatherCubit>().selectWeather(weather);
                  },
                ),
            };
          },
        ),
      ),
      floatingActionButton: _SearchButton(
        onPressed: () => Navigator.of(context).push(SearchPage.route()),
      ),
    );
  }
}

class _SearchButton extends StatelessWidget {
  const _SearchButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      key: const Key('weatherPage_searchButton'),
      onPressed: onPressed,
      child: Icon(Icons.search),
    );
  }
}

class _SettingIcon extends StatelessWidget {
  const _SettingIcon();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () => Navigator.of(context).push<void>(
        SettingsPage.route(),
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
