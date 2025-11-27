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
      humidity: $checkedConvert('humidity', (v) => (v as num?)?.toDouble()),
    );
    return val;
  },
  fieldKeyMap: const {
    'lastUpdated': 'last_updated',
    'windSpeed': 'wind_speed',
    'windDirection': 'wind_direction',
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
  'humidity': instance.humidity,
};

const _$WeatherConditionEnumMap = {
  WeatherCondition.clear: 'clear',
  WeatherCondition.rainy: 'rainy',
  WeatherCondition.cloudy: 'cloudy',
  WeatherCondition.snowy: 'snowy',
  WeatherCondition.unknown: 'unknown',
};
