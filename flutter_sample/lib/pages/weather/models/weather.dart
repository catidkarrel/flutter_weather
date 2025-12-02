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
  });

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);

  factory Weather.fromRepository(weather_repository.Weather weather) {
    return Weather(
      condition: weather.condition,
      lastUpdated: DateTime.now(),
      location: weather.location,
      temperature: Temperature(value: weather.temperature),
      latitude: weather.latitude.toString(),
      longitude: weather.longitude.toString(),
      windSpeed: weather.windSpeed,
      windDirection: weather.windDirection,
      apparentTemperature: weather.apparentTemperature,
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

  @override
  List<Object?> get props => [
    condition,
    lastUpdated,
    location,
    temperature,
    windSpeed,
    windDirection,
    apparentTemperature,
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
    );
  }
}
