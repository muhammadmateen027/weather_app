import 'package:equatable/equatable.dart';
import 'package:open_weather_api/open_weather_api.dart';

class Location extends Equatable {
  const Location({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromDto(CityDto dto) {
    return Location(
      name: dto.name,
      country: dto.country,
      latitude: dto.coord.lat,
      longitude: dto.coord.lon,
    );
  }

  final String name;
  final String country;
  final double latitude;
  final double longitude;

  @override
  List<Object?> get props => [name, country, latitude, longitude];
}
