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
      daily: $checkedConvert(
        'daily',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => DailyForecast.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      ),
      hourly: $checkedConvert(
        'hourly',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => HourlyForecast.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
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

DailyForecast _$DailyForecastFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'DailyForecast',
      json,
      ($checkedConvert) {
        final val = DailyForecast(
          date: $checkedConvert('date', (v) => v as String),
          weatherCode: $checkedConvert(
            'weather_code',
            (v) => (v as num).toDouble(),
          ),
          maxTemp: $checkedConvert('max_temp', (v) => (v as num).toDouble()),
          minTemp: $checkedConvert('min_temp', (v) => (v as num).toDouble()),
        );
        return val;
      },
      fieldKeyMap: const {
        'weatherCode': 'weather_code',
        'maxTemp': 'max_temp',
        'minTemp': 'min_temp',
      },
    );

HourlyForecast _$HourlyForecastFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('HourlyForecast', json, ($checkedConvert) {
  final val = HourlyForecast(
    time: $checkedConvert('time', (v) => v as String),
    temperature: $checkedConvert('temperature', (v) => (v as num).toDouble()),
    weatherCode: $checkedConvert('weather_code', (v) => (v as num).toDouble()),
  );
  return val;
}, fieldKeyMap: const {'weatherCode': 'weather_code'});
