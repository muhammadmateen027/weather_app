part of 'weather_populated.dart';

class _WeatherForecast extends StatelessWidget {
  const _WeatherForecast({
    required this.forecasts,
    required this.onCardTapped,
    required this.selectedWeather,
  });

  final List<DisplayWeather> forecasts;
  final ValueSetter<DisplayWeather> onCardTapped;
  final DisplayWeather selectedWeather;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 165, // Adjust this value based on your card size
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecasts.length,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        itemBuilder: (context, index) {
          final weather = forecasts.elementAt(index);
          return _WeatherCard(
            weather: weather,
            onTap: () => onCardTapped(weather),
            isSelected: selectedWeather == weather,
          );
        },
      ),
    );
  }
}

class _WeatherCard extends StatelessWidget {
  const _WeatherCard(
      {required this.weather, this.onTap, this.isSelected = false});

  final DisplayWeather weather;
  final VoidCallback? onTap;
  final bool isSelected;

  ShapeBorder? shape(Color color) {
    return isSelected
        ? RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: color, width: 1.0),
          )
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final outlineColor = Theme.of(context).colorScheme.outline;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: shape(outlineColor),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                weather.date.shortDayName,
                style: textTheme.headlineSmall,
              ),
              Text(
                '(${weather.date.formattedTime})',
                style: textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w200,
                ),
              ),
              Text(
                weather.condition.toEmoji,
                style: textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                weather.formattedTemperature,
                style: textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
