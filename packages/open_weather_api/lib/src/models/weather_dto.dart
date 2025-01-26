import 'package:json_annotation/json_annotation.dart';

part 'weather_dto.g.dart';

@JsonSerializable()
class WeatherDto {
  @JsonKey(name: 'main')
  final WeatherMainDto main;
  final List<WeatherConditionDto> weather;
  final WindDto wind;
  @JsonKey(name: 'dt_txt')
  final DateTime date;

  const WeatherDto({
    required this.main,
    required this.weather,
    required this.wind,
    required this.date,
  });

  factory WeatherDto.fromJson(Map<String, dynamic> json) =>
      _$WeatherDtoFromJson(json);
}

@JsonSerializable()
class WeatherMainDto {
  final double temp;
  final double pressure;
  final int humidity;

  const WeatherMainDto({
    required this.temp,
    required this.pressure,
    required this.humidity,
  });

  factory WeatherMainDto.fromJson(Map<String, dynamic> json) =>
      _$WeatherMainDtoFromJson(json);
}

@JsonSerializable()
class WeatherConditionDto {
  final String main;
  final String description;
  final String icon;

  const WeatherConditionDto({
    required this.main,
    required this.description,
    required this.icon,
  });

  factory WeatherConditionDto.fromJson(Map<String, dynamic> json) =>
      _$WeatherConditionDtoFromJson(json);
}

@JsonSerializable()
class WindDto {
  final double speed;

  const WindDto({required this.speed});

  factory WindDto.fromJson(Map<String, dynamic> json) =>
      _$WindDtoFromJson(json);
}
