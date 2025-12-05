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
  'daily': instance.daily,
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
          maxTemp: $checkedConvert('max_temp', (v) => (v as num).toDouble()),
          minTemp: $checkedConvert('min_temp', (v) => (v as num).toDouble()),
        );
        return val;
      },
      fieldKeyMap: const {'maxTemp': 'max_temp', 'minTemp': 'min_temp'},
    );

Map<String, dynamic> _$DailyForecastToJson(DailyForecast instance) =>
    <String, dynamic>{
      'date': instance.date,
      'condition': _$WeatherConditionEnumMap[instance.condition]!,
      'max_temp': instance.maxTemp,
      'min_temp': instance.minTemp,
    };
