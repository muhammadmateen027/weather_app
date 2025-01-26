import 'package:json_annotation/json_annotation.dart';

part 'location_dto.g.dart';

@JsonSerializable()
class LocationDto {
  final String name;
  final double lat;
  final double lon;
  final String country;

  const LocationDto({
    required this.name,
    required this.lat,
    required this.lon,
    required this.country,
  });

  factory LocationDto.fromJson(Map<String, dynamic> json) =>
      _$LocationDtoFromJson(json);
}
