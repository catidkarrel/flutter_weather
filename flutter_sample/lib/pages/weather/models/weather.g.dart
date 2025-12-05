// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Temperature _$TemperatureFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Temperature', json, ($checkedConvert) {
      final val = Temperature(
        value: $checkedConvert('value', (v) => (v as num).toDouble()),
      );
      return val;
    });

Map<String, dynamic> _$TemperatureToJson(Temperature instance) =>
    <String, dynamic>{'value': instance.value};

Weather _$WeatherFromJson(Map<String, dynamic> json) => $checkedCreate(
  'Weather',
  json,
  ($checkedConvert) {
    final val = Weather(
      condition: $checkedConvert(
        'condition',
        (v) => $enumDecode(_$WeatherConditionEnumMap, v),
      ),
      lastUpdated: $checkedConvert(
        'last_updated',
        (v) => DateTime.parse(v as String),
      ),
      location: $checkedConvert('location', (v) => v as String),
      temperature: $checkedConvert(
        'temperature',
        (v) => Temperature.fromJson(v as Map<String, dynamic>),
      ),
      latitude: $checkedConvert('latitude', (v) => v as String),
      longitude: $checkedConvert('longitude', (v) => v as String),
      windSpeed: $checkedConvert('wind_speed', (v) => (v as num?)?.toDouble()),
      windDirection: $checkedConvert(
        'wind_direction',
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
    );
    return val;
  },
  fieldKeyMap: const {
    'lastUpdated': 'last_updated',
    'windSpeed': 'wind_speed',
    'windDirection': 'wind_direction',
    'apparentTemperature': 'apparent_temperature',
  },
);

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
  'condition': _$WeatherConditionEnumMap[instance.condition]!,
  'last_updated': instance.lastUpdated.toIso8601String(),
  'location': instance.location,
  'temperature': instance.temperature.toJson(),
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'wind_speed': instance.windSpeed,
  'wind_direction': instance.windDirection,
  'apparent_temperature': instance.apparentTemperature,
  'daily': instance.daily.map((e) => e.toJson()).toList(),
};

const _$WeatherConditionEnumMap = {
  WeatherCondition.clear: 'clear',
  WeatherCondition.rainy: 'rainy',
  WeatherCondition.cloudy: 'cloudy',
  WeatherCondition.snowy: 'snowy',
  WeatherCondition.unknown: 'unknown',
};

DailyForecast _$DailyForecastFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'DailyForecast',
      json,
      ($checkedConvert) {
        final val = DailyForecast(
          date: $checkedConvert('date', (v) => v as String),
          condition: $checkedConvert(
            'condition',
            (v) => $enumDecode(_$WeatherConditionEnumMap, v),
          ),
          maxTemp: $checkedConvert(
            'max_temp',
            (v) => Temperature.fromJson(v as Map<String, dynamic>),
          ),
          minTemp: $checkedConvert(
            'min_temp',
            (v) => Temperature.fromJson(v as Map<String, dynamic>),
          ),
        );
        return val;
      },
      fieldKeyMap: const {'maxTemp': 'max_temp', 'minTemp': 'min_temp'},
    );

Map<String, dynamic> _$DailyForecastToJson(DailyForecast instance) =>
    <String, dynamic>{
      'date': instance.date,
      'condition': _$WeatherConditionEnumMap[instance.condition]!,
      'max_temp': instance.maxTemp.toJson(),
      'min_temp': instance.minTemp.toJson(),
    };
