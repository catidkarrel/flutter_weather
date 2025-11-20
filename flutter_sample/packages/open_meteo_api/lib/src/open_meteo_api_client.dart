import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:open_meteo_api/open_meteo_api.dart';

/// Exception for location request failure
class LocationRequestFailure implements Exception {}

/// Exception for location not found failure
class LocationNotFoundFailure implements Exception {}

/// Exception for weather request failure
class WeatherRequestFailure implements Exception {}

/// Exception for weather not found failure
class WeatherNotFoundFailure implements Exception {}

/// Class for handling open-meteo api operations
class OpenMeteoApiClient {
  OpenMeteoApiClient({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  /// Base url for weather api
  static const _baseUrlWeather = 'api.open-meteo.com';
  /// Base url for geocoding api
  static const _baseUrlGeocoding = 'geocoding-api.open-meteo.com';
  /// Http client
  final http.Client _httpClient;

  /// Search location by name
  Future<Location> locationSearch(String query) async {
    final locationRequest = Uri.https(
      _baseUrlGeocoding,
      '/v1/search',
      {'name': query, 'count': '1'},
    );

    /// Make request to geocoding api
    final locationResponse = await _httpClient.get(locationRequest);

    if (locationResponse.statusCode != 200) {
      throw LocationRequestFailure();
    }

    /// Parse response body to json
    final locationJson = jsonDecode(locationResponse.body) as Map<String, dynamic>;

    final resultsRaw = locationJson['results'];

    /// Validate: must be a List AND not empty
    if (resultsRaw is! List || resultsRaw.isEmpty) {
      throw LocationNotFoundFailure();
    }

    final results = resultsRaw.cast<Map<String, dynamic>>();

    return Location.fromJson(results.first);
  }

  /// Get weather by latitude and longitude
  Future<Weather> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final weatherRequest = Uri.https(_baseUrlWeather, 'v1/forecast', 
    {'latitude': '$latitude',
     'longitude': '$longitude',
     'current_weather': 'true'
    });

    /// Make request to weather api
    final weatherResponse = await _httpClient.get(weatherRequest);

    if (weatherResponse.statusCode != 200) {
     throw WeatherRequestFailure;
    }

    /// Parse response body to json
    final bodyJson = jsonDecode(weatherResponse.body) as Map<String, dynamic>;

    if (!bodyJson.containsKey('current_weather')) {
      throw WeatherNotFoundFailure();
    }

    final weatherJson = bodyJson['current_weather'] as Map<String, dynamic>;

    return Weather.fromJson(weatherJson);
  }

  /// Close http client
  void close() {
    _httpClient.close();
  }
}