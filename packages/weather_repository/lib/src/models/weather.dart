class Weather {
  const Weather({
    required this.condition,
    required this.description,
    required this.iconCode,
    required this.temperature,
    required this.pressure,
    required this.humidity,
    required this.windSpeed,
    required this.date,
  });

  final String condition;
  final String description;
  final String iconCode;
  final double temperature;
  final double pressure;
  final int humidity;
  final double windSpeed;
  final DateTime date;
}
