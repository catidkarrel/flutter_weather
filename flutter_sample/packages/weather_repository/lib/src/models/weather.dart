import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

enum WeatherCondition { clear, rainy, cloudy, snowy, unknown }

@JsonSerializable()
class Weather extends Equatable {
  const Weather({
    required this.location,
    required this.temperature,
    required this.condition,
    required this.latitude,
    required this.longitude,
    this.windSpeed,
    this.windDirection,
    this.humidity,
  });

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherToJson(this);

  final String location;
  final double temperature;
  final WeatherCondition condition;
  final String latitude;
  final String longitude;
  final double? windSpeed;
  final double? windDirection;
  final double? humidity;

  @override
  List<Object?> get props => [
    location,
    temperature,
    condition,
    windSpeed,
    windDirection,
    humidity,
  ];
}
