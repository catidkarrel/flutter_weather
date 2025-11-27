library weather_repository;

export 'src/models/models.dart';
export 'weather_repository.dart';

import 'dart:async';

import 'package:open_meteo_api/open_meteo_api.dart' hide Weather;
import 'package:weather_repository/location_repository.dart';
import 'package:weather_repository/weather_repository.dart';

/// Class for handling weather related operations.
class WeatherRepository {
  WeatherRepository({
    OpenMeteoApiClient? weatherApiClient,
    LocationRepository? locationRepository,
    required this.baseUrlWeather,
    required this.baseUrlGeocoding,
    this.enableLogs = false,
  }) : _weatherApiClient =
           weatherApiClient ??
           OpenMeteoApiClient(
             aBaseUrlWeather: baseUrlWeather,
             aBaseUrlGeocoding: baseUrlGeocoding,
             enableLogs: enableLogs,
           ),
       _locationRepository = locationRepository ?? LocationRepository();

  final String baseUrlWeather;
  final String baseUrlGeocoding;
  final bool enableLogs;

  /// Weather api client
  final OpenMeteoApiClient _weatherApiClient;

  /// Location repository
  final LocationRepository _locationRepository;

  /// Get weather by current location
  Future<Weather> getWeatherByLocation() async {
    final position = await _locationRepository.getCurrentPosition();
    final location = await _locationRepository.getPlaceNameFromCoordinates(
      position.latitude,
      position.longitude,
    );
    final weather = await _weatherApiClient.getWeather(
      latitude: position.latitude,
      longitude: position.longitude,
    );
    return Weather(
      location: location,
      temperature: weather.temperature,
      condition: weather.weatherCode.toInt().toCondition,
      latitude: position.latitude.toString(),
      longitude: position.longitude.toString(),
      windSpeed: weather.windSpeed,
      windDirection: weather.windDirection,
      humidity: weather.humidity,
    );
  }

  /// Get weather by city name
  Future<Weather> getWeather(String city) async {
    final location = await _weatherApiClient.locationSearch(city);
    final weather = await _weatherApiClient.getWeather(
      latitude: location.latitude,
      longitude: location.longitude,
    );
    return Weather(
      temperature: weather.temperature,
      location: location.name,
      condition: weather.weatherCode.toInt().toCondition,
      latitude: location.latitude.toString(),
      longitude: location.longitude.toString(),
      windSpeed: weather.windSpeed,
      windDirection: weather.windDirection,
      humidity: weather.humidity,
    );
  }

  /// Get weather by coordinates
  Future<Weather> getWeatherByCoordinates({
    required double latitude,
    required double longitude,
    required String locationName,
  }) async {
    final weather = await _weatherApiClient.getWeather(
      latitude: latitude,
      longitude: longitude,
    );
    return Weather(
      temperature: weather.temperature,
      location: locationName,
      condition: weather.weatherCode.toInt().toCondition,
      latitude: latitude.toString(),
      longitude: longitude.toString(),
      windSpeed: weather.windSpeed,
      windDirection: weather.windDirection,
      humidity: weather.humidity,
    );
  }

  /// Dispose weather api client
  void dispose() => _weatherApiClient.close();
}

/// Extension for converting weather code to weather condition
extension on int {
  WeatherCondition get toCondition {
    switch (this) {
      case 0:
        return WeatherCondition.clear;
      case 1:
      case 2:
      case 3:
      case 45:
      case 48:
        return WeatherCondition.cloudy;
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
      case 95:
      case 96:
      case 99:
        return WeatherCondition.rainy;
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return WeatherCondition.snowy;
      default:
        return WeatherCondition.unknown;
    }
  }
}
