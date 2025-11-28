import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

/// Class for handling location data
@JsonSerializable()
class Location {
  const Location({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.country,
    this.admin1,
  });

  /// Factory constructor for creating Location instance from json
  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  /// Id of location
  final int id;

  /// Name of location
  final String name;

  /// Latitude of location
  final double latitude;

  /// Longitude of location
  final double longitude;

  /// Country of location
  final String? country;

  /// Admin1 (Region) of location
  final String? admin1;
}
