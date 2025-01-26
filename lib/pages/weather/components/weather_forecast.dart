part of 'weather_populated.dart';

class _WeatherForecast extends StatelessWidget {
  const _WeatherForecast({
    required this.forecasts,
    required this.onCardTapped,
  });

  final List<DisplayWeather> forecasts;
  final ValueSetter<DisplayWeather> onCardTapped;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180, // Adjust this value based on your card size
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecasts.length,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        itemBuilder: (context, index) {
          final forecast = forecasts[index];
          return _WeatherCard(
            weather: forecast,
            onTap: () => onCardTapped(forecast),
          );
        },
      ),
    );
  }
}

class _WeatherCard extends StatelessWidget {
  const _WeatherCard({required this.weather, this.onTap});

  final DisplayWeather weather;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
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
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 8),
              Text(
                weather.formattedTemperature,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
