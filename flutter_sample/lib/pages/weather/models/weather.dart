import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weather_repository/weather_repository.dart' hide Weather;
import 'package:weather_repository/weather_repository.dart'
    as weather_repository;

part 'weather.g.dart';

enum TemperatureUnits { fahrenheit, celsius }

extension TemperatureUnitsX on TemperatureUnits {
  bool get isFahrenheit => this == TemperatureUnits.fahrenheit;
  bool get isCelsius => this == TemperatureUnits.celsius;
}

@JsonSerializable()
class Temperature extends Equatable {
  const Temperature({required this.value});

  factory Temperature.fromJson(Map<String, dynamic> json) =>
      _$TemperatureFromJson(json);

  final double value;

  Map<String, dynamic> toJson() => _$TemperatureToJson(this);

  @override
  List<Object> get props => [value];
}

@JsonSerializable()
class Weather extends Equatable {
  const Weather({
    required this.condition,
    required this.lastUpdated,
    required this.location,
    required this.temperature,
    required this.latitude,
    required this.longitude,
    this.windSpeed,
    this.windDirection,
    this.apparentTemperature,
    this.daily = const [],
  });

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);

  factory Weather.fromRepository(weather_repository.Weather weather) {
    return Weather(
      condition: weather.condition,
      lastUpdated: DateTime.now(),
      location: weather.location,
      temperature: Temperature(value: weather.temperature),
      latitude: weather.latitude,
      longitude: weather.longitude,
      windSpeed: weather.windSpeed,
      windDirection: weather.windDirection,
      apparentTemperature: weather.apparentTemperature,
      daily: weather.daily
          .map(
            (d) => DailyForecast(
              date: d.date,
              condition: d.condition,
              maxTemp: Temperature(value: d.maxTemp),
              minTemp: Temperature(value: d.minTemp),
            ),
          )
          .toList(),
    );
  }

  static final empty = Weather(
    condition: WeatherCondition.unknown,
    lastUpdated: DateTime(0),
    temperature: const Temperature(value: 0),
    location: '--',
    latitude: '0',
    longitude: '0',
  );

  final WeatherCondition condition;
  final DateTime lastUpdated;
  final String location;
  final Temperature temperature;
  final String latitude;
  final String longitude;
  final double? windSpeed;
  final double? windDirection;
  final double? apparentTemperature;
  final List<DailyForecast> daily;

  @override
  List<Object?> get props => [
    condition,
    lastUpdated,
    location,
    temperature,
    windSpeed,
    windDirection,
    apparentTemperature,
    daily,
  ];

  Map<String, dynamic> toJson() => _$WeatherToJson(this);

  Weather copyWith({
    WeatherCondition? condition,
    DateTime? lastUpdated,
    String? location,
    Temperature? temperature,
    String? latitude,
    String? longitude,
    double? windSpeed,
    double? windDirection,
    double? apparentTemperature,
    List<DailyForecast>? daily,
  }) {
    return Weather(
      condition: condition ?? this.condition,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      location: location ?? this.location,
      temperature: temperature ?? this.temperature,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      windSpeed: windSpeed ?? this.windSpeed,
      windDirection: windDirection ?? this.windDirection,
      apparentTemperature: apparentTemperature ?? this.apparentTemperature,
      daily: daily ?? this.daily,
    );
  }
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
  final Temperature maxTemp;
  final Temperature minTemp;

  @override
  List<Object?> get props => [date, condition, maxTemp, minTemp];
}
