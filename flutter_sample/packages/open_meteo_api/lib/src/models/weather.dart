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
    this.daily = const [],
    this.hourly = const [],
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

  /// Daily forecast
  final List<DailyForecast> daily;

  /// Hourly forecast
  final List<HourlyForecast> hourly;
}

@JsonSerializable()
class DailyForecast {
  const DailyForecast({
    required this.date,
    required this.weatherCode,
    required this.maxTemp,
    required this.minTemp,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) =>
      _$DailyForecastFromJson(json);

  final String date;
  final double weatherCode;
  final double maxTemp;
  final double minTemp;
}

@JsonSerializable()
class HourlyForecast {
  const HourlyForecast({
    required this.time,
    required this.temperature,
    required this.weatherCode,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) =>
      _$HourlyForecastFromJson(json);

  final String time;
  final double temperature;
  final double weatherCode;
}
