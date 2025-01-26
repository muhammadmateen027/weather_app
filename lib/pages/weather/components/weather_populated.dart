import 'package:flutter/material.dart';
import 'package:weather_app/models/display_weather.dart';
import 'package:weather_repository/weather_repository.dart';

class WeatherPopulated extends StatelessWidget {
  const WeatherPopulated({
    required this.weather,
    required this.location,
    required this.units,
    required this.onRefresh,
    super.key,
  });

  final DisplayWeather weather;
  final Location location;
  final TemperatureUnit units;
  final ValueGetter<Future<void>> onRefresh;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _WeatherBackground(),
        RefreshIndicator(
          onRefresh: onRefresh,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 100),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              clipBehavior: Clip.none,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _WeatherCondition(condition: weather.weatherCondition),
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
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WeatherBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primaryContainer;
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.25, 0.75, 0.90, 1.0],
            colors: [
              color,
              color.brighten(),
              color.brighten(33),
              color.brighten(50),
            ],
          ),
        ),
      ),
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
          Text(
            location.name,
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w200,
            ),
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
  final int humidity;
  final int pressure;
  final double windSpeed;

  const WeatherMetrics({
    super.key,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _MetricItem(
            icon: Icons.water_drop,
            value: '$humidity%',
            label: 'Humidity',
          ),
          _MetricItem(
            icon: Icons.speed,
            value: '${pressure.round()}hPa',
            label: 'Pressure',
          ),
          _MetricItem(
            icon: Icons.air,
            value: '${windSpeed.toStringAsFixed(1)}km/h',
            label: 'Wind',
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _MetricItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Icon(icon, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: textTheme.bodyLarge,
        ),
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}

extension _ColorX on Color {
  Color brighten([int percent = 10]) {
    assert(
      1 <= percent && percent <= 100,
      'percentage must be between 1 and 100',
    );
    final p = percent / 100;
    final alpha = a.round();
    final red = r.round();
    final green = g.round();
    final blue = b.round();
    return Color.fromARGB(
      alpha,
      red + ((255 - red) * p).round(),
      green + ((255 - green) * p).round(),
      blue + ((255 - blue) * p).round(),
    );
  }
}
