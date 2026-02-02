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
    this.apparentTemperature,
    this.daily = const [],
    this.hourly = const [],
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
  final double? apparentTemperature;
  final List<DailyForecast> daily;
  final List<HourlyForecast> hourly;

  @override
  List<Object?> get props => [
    location,
    temperature,
    condition,
    windSpeed,
    windDirection,
    apparentTemperature,
    daily,
    hourly,
  ];
}

@JsonSerializable()
class DailyForecast extends Equatable {
  const DailyForecast({
    required this.date,
    required this.condition,
    required this.maxTemp,
    required this.minTemp,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) =>
      _$DailyForecastFromJson(json);

  Map<String, dynamic> toJson() => _$DailyForecastToJson(this);

  final String date;
  final WeatherCondition condition;
  final double maxTemp;
  final double minTemp;

  @override
  List<Object?> get props => [date, condition, maxTemp, minTemp];
}

@JsonSerializable()
class HourlyForecast extends Equatable {
  const HourlyForecast({
    required this.time,
    required this.temperature,
    required this.condition,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) =>
      _$HourlyForecastFromJson(json);

  Map<String, dynamic> toJson() => _$HourlyForecastToJson(this);

  final String time;
  final double temperature;
  final WeatherCondition condition;

  @override
  List<Object?> get props => [time, temperature, condition];
}
