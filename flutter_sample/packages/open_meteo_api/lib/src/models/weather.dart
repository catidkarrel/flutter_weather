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
    this.humidity,
  });

  /// Factory constructor for creating Weather instance from json
  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);

  /// Temperature in celsius
  final double temperature;

  /// Weather code
  @JsonKey(name: 'weathercode')
  final double weatherCode;

  /// Wind speed in km/h
  @JsonKey(name: 'windspeed')
  final double? windSpeed;

  /// Wind direction in degrees
  @JsonKey(name: 'winddirection')
  final double? windDirection;

  /// Relative humidity in %
  final double? humidity;
}
