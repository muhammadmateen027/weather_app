import 'package:flutter/material.dart';
import 'package:weather_app/models/display_weather.dart';
import 'package:weather_app/utils/utils.dart';
import 'package:weather_repository/weather_repository.dart';

part 'weather_background.dart';
part 'weather_forecast.dart';

class WeatherPopulated extends StatelessWidget {
  const WeatherPopulated({
    required this.weather,
    required this.location,
    required this.onRefresh,
    required this.forecasts,
    required this.onCardTapped,
    super.key,
  });

  final DisplayWeather weather;
  final Location location;
  final ValueGetter<Future<void>> onRefresh;
  final List<DisplayWeather> forecasts;
  final ValueSetter<DisplayWeather> onCardTapped;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _WeatherBackground(),
        RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            clipBehavior: Clip.none,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _WeatherDetail(weather: weather, location: location),
                const SizedBox(height: 46),
                _WeatherForecast(
                  forecasts: forecasts,
                  onCardTapped: onCardTapped,
                  selectedWeather: weather,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _WeatherDetail extends StatelessWidget {
  const _WeatherDetail({
    required this.weather,
    required this.location,
  });

  final DisplayWeather weather;
  final Location location;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 120),
        _WeatherCondition(condition: weather.condition),
        _WeatherStatusAndLocation(
          location: location,
          temperature: weather.formattedTemperature,
        ),
        WeatherMetrics(
          humidity: weather.humidity,
          pressure: weather.pressure,
          windSpeed: weather.windSpeed,
        ),
        Text(
          '''Last Updated at ${TimeOfDay.fromDateTime(weather.date).format(context)}''',
        ),
      ],
    );
  }
}

class _WeatherCondition extends StatelessWidget {
  const _WeatherCondition({required this.condition});

  static const _iconSize = 95.0;

  final WeatherCondition condition;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(condition.name, style: const TextStyle(fontSize: 32)),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            condition.toEmoji,
            style: const TextStyle(fontSize: _iconSize),
          ),
        ),
      ],
    );
  }
}

class _WeatherStatusAndLocation extends StatelessWidget {
  const _WeatherStatusAndLocation({
    required this.location,
    required this.temperature,
  });

  final Location location;
  final String temperature;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                location.name,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w200,
                ),
              ),
              Text(
                '(${location.country})',
                style: theme.textTheme.labelSmall?.copyWith(),
              ),
            ],
          ),
          Text(
            temperature,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}

class WeatherMetrics extends StatelessWidget {
  const WeatherMetrics({
    super.key,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
  });

  final int humidity;
  final int pressure;
  final double windSpeed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _MetricItem(
            icon: Icons.water_drop,
            value: '$humidity %',
            label: 'Humidity',
          ),
          _MetricItem(
            icon: Icons.speed,
            value: '${pressure.round()} hPa',
            label: 'Pressure',
          ),
          _MetricItem(
            icon: Icons.air,
            value: '${windSpeed.toStringAsFixed(1)} km/h',
            label: 'Wind',
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Icon(icon, size: 24),
        const SizedBox(height: 4),
        Text(value, style: textTheme.bodyLarge),
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryFixed,
          ),
        ),
      ],
    );
  }
}
