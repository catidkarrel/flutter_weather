import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

/// Class for handling weather data
@JsonSerializable()
class Weather {
  const Weather({
    required this.temperature,
    required this.weatherCode,
    this.windSpeed,
    this.windDirection,
    this.apparentTemperature,
  });

  /// Factory constructor for creating Weather instance from json
  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);

  /// Temperature in celsius
  final double temperature;

  /// Weather code
  @JsonKey(name: 'weather_code')
  final double weatherCode;

  /// Wind speed in km/h
  @JsonKey(name: 'wind_speed_10m')
  final double? windSpeed;

  /// Wind direction in degrees
  @JsonKey(name: 'wind_direction_10m')
  final double? windDirection;

  /// Apparent temperature in celsius
  @JsonKey(name: 'apparent_temperature')
  final double? apparentTemperature;
}
