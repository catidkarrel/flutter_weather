import 'dart:async';

import 'package:dio/dio.dart';
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
  OpenMeteoApiClient({
    Dio? dioClient,
    required this.aBaseUrlWeather,
    required this.aBaseUrlGeocoding,
    this.enableLogs = false
  }) : _dioClient = dioClient ?? Dio();

  /// Base url for weather api
  //static const _baseUrlWeather = ;
  /// Base url for geocoding api
  //static const _baseUrlGeocoding = 'geocoding-api.open-meteo.com';
  /// Http client
  //final http.Client _httpClient;

  final Dio _dioClient;

  final String aBaseUrlWeather;
  final String aBaseUrlGeocoding;
  final bool enableLogs;

  /// Search location by name
  Future<Location> locationSearch(String query) async {
    final locationUri = Uri.https(
      aBaseUrlGeocoding,
      '/v1/search',
      {'name': query, 'count': '1'},
    );

    try {
      /// Make request to geocoding api
      //final locationResponse = await _httpClient.get(locationUri);
      final locationResponse = await _dioClient.getUri(locationUri);

      if (locationResponse.statusCode != 200) {
        throw LocationRequestFailure();
      }

      /// Parse response body to json
      //final locationJson = jsonDecode(locationResponse.body) as Map<String, dynamic>;
      final locationJson = locationResponse.data;

      final resultsRaw = locationJson['results'];

      /// Validate: must be a List AND not empty
      if (resultsRaw is! List || resultsRaw.isEmpty) {
        throw LocationNotFoundFailure();
      }

      final results = resultsRaw.cast<Map<String, dynamic>>();

      return Location.fromJson(results.first);
    } on DioException {
      throw LocationRequestFailure();
    }
  }

  /// Get weather by latitude and longitude
  Future<Weather> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final weatherUri = Uri.https(aBaseUrlWeather, 'v1/forecast', 
    {'latitude': '$latitude',
     'longitude': '$longitude',
     'current_weather': 'true'
    });

    try {
      /// Make request to weather api
      //final weatherResponse = await _httpClient.get(weatherRequest);
      final weatherResponse = await _dioClient.getUri(weatherUri);

      if (weatherResponse.statusCode != 200) {
        throw WeatherRequestFailure;
      }

      /// Parse response body to json
      //final bodyJson = jsonDecode(weatherResponse.body) as Map<String, dynamic>;
      final bodyJson = weatherResponse.data;

      if (!bodyJson.containsKey('current_weather')) {
        throw WeatherNotFoundFailure();
      }

      final weatherJson = bodyJson['current_weather'] as Map<String, dynamic>;

      return Weather.fromJson(weatherJson);
    } on DioException {
      throw WeatherRequestFailure();
    }
    
  }

  /// Close http client
  void close() {
    //_httpClient.close();
    _dioClient.close();
  }
}