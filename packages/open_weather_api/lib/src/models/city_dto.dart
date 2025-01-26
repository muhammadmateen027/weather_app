import 'package:json_annotation/json_annotation.dart';

part 'city_dto.g.dart';

@JsonSerializable(createToJson: false)
class CityDto {
  const CityDto({
    required this.name,
    required this.coord,
    required this.country,
  });

  factory CityDto.fromJson(Map<String, dynamic> json) =>
      _$CityDtoFromJson(json);
  final String name;
  final CoordDto coord;
  final String country;
}

@JsonSerializable(createToJson: false)
class CoordDto {
  const CoordDto({required this.lat, required this.lon});

  factory CoordDto.fromJson(Map<String, dynamic> json) =>
      _$CoordDtoFromJson(json);

  final double lat;
  final double lon;
}
