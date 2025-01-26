import 'package:json_annotation/json_annotation.dart';

part 'weather_data_dto.g.dart';

@JsonSerializable(createToJson: false)
class WeatherDataDto {
  const WeatherDataDto({
    required this.main,
    required this.weather,
    required this.wind,
    required this.dtTxt,
  });

  factory WeatherDataDto.fromJson(Map<String, dynamic> json) =>
      _$WeatherDataDtoFromJson(json);

  final MainDataDto main;
  final List<WeatherDto> weather;
  final WindDto wind;
  @JsonKey(name: 'dt_txt')
  final String dtTxt;
}

@JsonSerializable(createToJson: false)
class WeatherDto {
  const WeatherDto({
    required this.main,
    required this.description,
    required this.icon,
  });

  factory WeatherDto.fromJson(Map<String, dynamic> json) =>
      _$WeatherDtoFromJson(json);
  final String main;
  final String description;
  final String icon;
}

@JsonSerializable(createToJson: false)
class MainDataDto {
  const MainDataDto({
    required this.temp,
    required this.pressure,
    required this.humidity,
  });

  factory MainDataDto.fromJson(Map<String, dynamic> json) =>
      _$MainDataDtoFromJson(json);

  final double temp;
  final int pressure;
  final int humidity;
}

@JsonSerializable(createToJson: false)
class WindDto {
  const WindDto({required this.speed});

  factory WindDto.fromJson(Map<String, dynamic> json) =>
      _$WindDtoFromJson(json);

  final double speed;
}
