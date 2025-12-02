// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) => $checkedCreate(
  'Weather',
  json,
  ($checkedConvert) {
    final val = Weather(
      location: $checkedConvert('location', (v) => v as String),
      temperature: $checkedConvert('temperature', (v) => (v as num).toDouble()),
      condition: $checkedConvert(
        'condition',
        (v) => $enumDecode(_$WeatherConditionEnumMap, v),
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
    );
    return val;
  },
  fieldKeyMap: const {
    'windSpeed': 'wind_speed',
    'windDirection': 'wind_direction',
    'apparentTemperature': 'apparent_temperature',
  },
);

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
  'location': instance.location,
  'temperature': instance.temperature,
  'condition': _$WeatherConditionEnumMap[instance.condition]!,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'wind_speed': instance.windSpeed,
  'wind_direction': instance.windDirection,
  'apparent_temperature': instance.apparentTemperature,
};

const _$WeatherConditionEnumMap = {
  WeatherCondition.clear: 'clear',
  WeatherCondition.rainy: 'rainy',
  WeatherCondition.cloudy: 'cloudy',
  WeatherCondition.snowy: 'snowy',
  WeatherCondition.unknown: 'unknown',
};
