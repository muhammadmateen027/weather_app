import 'package:equatable/equatable.dart';

class DisplayLocation extends Equatable {
  const DisplayLocation({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  final String name;
  final String country;
  final double latitude;
  final double longitude;

  @override
  List<Object?> get props => [name, country, latitude, longitude];
}
