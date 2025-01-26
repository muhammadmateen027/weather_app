import 'package:json_annotation/json_annotation.dart';

import 'models.dart';

part 'forecast_dto.g.dart';

@JsonSerializable()
class ForecastDto {
  const ForecastDto({required this.list, required this.city});

  factory ForecastDto.fromJson(Map<String, dynamic> json) =>
      _$ForecastDtoFromJson(json);

  final List<WeatherDataDto> list;
  final CityDto city;
}
