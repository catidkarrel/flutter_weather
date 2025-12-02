// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) => $checkedCreate(
  'Weather',
  json,
  ($checkedConvert) {
    final val = Weather(
      temperature: $checkedConvert('temperature', (v) => (v as num).toDouble()),
      weatherCode: $checkedConvert(
        'weather_code',
        (v) => (v as num).toDouble(),
      ),
      windSpeed: $checkedConvert(
        'wind_speed_10m',
        (v) => (v as num?)?.toDouble(),
      ),
      windDirection: $checkedConvert(
        'wind_direction_10m',
        (v) => (v as num?)?.toDouble(),
      ),
      apparentTemperature: $checkedConvert(
        'apparent_temperature',
        (v) => (v as num?)?.toDouble(),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'weatherCode': 'weather_code',
    'windSpeed': 'wind_speed_10m',
    'windDirection': 'wind_direction_10m',
    'apparentTemperature': 'apparent_temperature',
  },
);
