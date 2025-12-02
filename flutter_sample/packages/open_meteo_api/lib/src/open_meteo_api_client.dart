import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:open_meteo_api/open_meteo_api.dart';

/// Class for handling open-meteo api operations
class OpenMeteoApiClient {
  OpenMeteoApiClient({
    Dio? dioClient,
    required this.aBaseUrlWeather,
    required this.aBaseUrlGeocoding,
    this.enableLogs = false,
    this.timeout = const Duration(seconds: 10),
    this.maxRetries = 3,
  }) : _dioClient = dioClient ?? Dio() {
    _configureDio();
  }

  final Dio _dioClient;
  final String aBaseUrlWeather;
  final String aBaseUrlGeocoding;
  final bool enableLogs;
  final Duration timeout;
  final int maxRetries;

  /// Configure Dio with timeout and interceptors
  void _configureDio() {
    _dioClient.options = BaseOptions(
      connectTimeout: timeout,
      receiveTimeout: timeout,
      sendTimeout: timeout,
    );

    if (enableLogs) {
      _dioClient.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
          logPrint: (obj) => log('[API] $obj'),
        ),
      );
    }
  }

  /// Execute request with retry logic
  Future<T> _executeWithRetry<T>(
    Future<T> Function() request, {
    int retryCount = 0,
  }) async {
    try {
      return await request();
    } on DioException catch (e, stackTrace) {
      // Check if we should retry
      if (retryCount < maxRetries && _shouldRetry(e)) {
        // Exponential backoff: 1s, 2s, 4s
        final delay = Duration(seconds: 1 << retryCount);
        await Future<void>.delayed(delay);
        return _executeWithRetry(request, retryCount: retryCount + 1);
      }

      // Convert DioException to our custom exceptions
      throw _handleDioException(e, stackTrace);
    }
  }

  /// Determine if request should be retried
  bool _shouldRetry(DioException error) {
    // Retry on network errors, timeouts, and 5xx server errors
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.connectionError ||
        (error.response?.statusCode != null &&
            error.response!.statusCode! >= 500);
  }

  /// Convert DioException to custom exceptions
  Exception _handleDioException(DioException error, StackTrace stackTrace) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return TimeoutException(
          statusCode: error.response?.statusCode,
          stackTrace: stackTrace,
        );

      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return NetworkException(
          statusCode: error.response?.statusCode,
          stackTrace: stackTrace,
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode != null) {
          if (statusCode >= 500) {
            return ServerException(
              statusCode: statusCode,
              stackTrace: stackTrace,
            );
          } else if (statusCode >= 400) {
            return ClientException(
              statusCode: statusCode,
              stackTrace: stackTrace,
            );
          }
        }
        return ApiException(
          message: 'Request failed: ${error.message}',
          statusCode: statusCode,
          stackTrace: stackTrace,
        );

      default:
        return ApiException(
          message: 'Unexpected error: ${error.message}',
          statusCode: error.response?.statusCode,
          stackTrace: stackTrace,
        );
    }
  }

  /// Search location by name
  Future<Location> locationSearch(String query) async {
    return _executeWithRetry(() async {
      final locationUri = Uri.https(aBaseUrlGeocoding, '/v1/search', {
        'name': query,
        'count': '1',
      });

      final locationResponse = await _dioClient.getUri(locationUri);

      if (locationResponse.statusCode != 200) {
        throw LocationRequestFailure();
      }

      final locationJson = locationResponse.data;
      final resultsRaw = locationJson['results'];

      /// Validate: must be a List AND not empty
      if (resultsRaw is! List || resultsRaw.isEmpty) {
        throw LocationNotFoundException();
      }

      final results = resultsRaw.cast<Map<String, dynamic>>();
      return Location.fromJson(results.first);
    });
  }

  /// Search location suggestions by name
  Future<List<Location>> locationSearchSuggestions(String query) async {
    return _executeWithRetry(() async {
      final locationUri = Uri.https(aBaseUrlGeocoding, '/v1/search', {
        'name': query,
        'count': '10',
      });

      final locationResponse = await _dioClient.getUri(locationUri);

      if (locationResponse.statusCode != 200) {
        throw LocationRequestFailure();
      }

      final locationJson = locationResponse.data;
      final resultsRaw = locationJson['results'];

      if (resultsRaw is! List || resultsRaw.isEmpty) {
        return [];
      }

      final results = resultsRaw.cast<Map<String, dynamic>>();
      return results.map((e) => Location.fromJson(e)).toList();
    });
  }

  /// Get weather by latitude and longitude
  Future<Weather> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    return _executeWithRetry(() async {
      final weatherUri = Uri.https(aBaseUrlWeather, 'v1/forecast', {
        'latitude': '$latitude',
        'longitude': '$longitude',
        'current':
            'temperature_2m,apparent_temperature,wind_speed_10m,wind_direction_10m,weather_code',
      });

      final weatherResponse = await _dioClient.getUri(weatherUri);

      if (weatherResponse.statusCode != 200) {
        throw WeatherRequestFailure();
      }

      final bodyJson = weatherResponse.data;

      if (!bodyJson.containsKey('current')) {
        throw WeatherDataNotFoundException();
      }

      final current = bodyJson['current'] as Map<String, dynamic>;

      // Extract weather data from current object
      final temperature = (current['temperature_2m'] as num?)?.toDouble();
      final apparentTemperature = (current['apparent_temperature'] as num?)
          ?.toDouble();
      final windSpeed = (current['wind_speed_10m'] as num?)?.toDouble();
      final windDirection = (current['wind_direction_10m'] as num?)?.toDouble();
      final weatherCode = (current['weather_code'] as num?)?.toDouble();

      if (temperature == null || weatherCode == null) {
        throw WeatherDataNotFoundException();
      }

      return Weather(
        temperature: temperature,
        weatherCode: weatherCode,
        windSpeed: windSpeed,
        windDirection: windDirection,
        apparentTemperature: apparentTemperature,
      );
    });
  }

  /// Close http client
  void close() {
    _dioClient.close();
  }
}
