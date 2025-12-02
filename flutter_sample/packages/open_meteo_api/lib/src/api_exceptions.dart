/// Base exception class for API errors
class ApiException implements Exception {
  const ApiException({required this.message, this.statusCode, this.stackTrace});

  final String message;
  final int? statusCode;
  final StackTrace? stackTrace;

  @override
  String toString() =>
      'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// Exception thrown when there are network connectivity issues
class NetworkException extends ApiException {
  const NetworkException({
    super.message =
        'Network connection failed. Please check your internet connection.',
    super.statusCode,
    super.stackTrace,
  });
}

/// Exception thrown when a request times out
class TimeoutException extends ApiException {
  const TimeoutException({
    super.message = 'Request timed out. Please try again.',
    super.statusCode,
    super.stackTrace,
  });
}

/// Exception thrown for server-side errors (5xx)
class ServerException extends ApiException {
  const ServerException({
    super.message = 'Server error occurred. Please try again later.',
    super.statusCode,
    super.stackTrace,
  });
}

/// Exception thrown for client-side errors (4xx)
class ClientException extends ApiException {
  const ClientException({
    super.message = 'Invalid request. Please check your input.',
    super.statusCode,
    super.stackTrace,
  });
}

/// Exception thrown when location is not found
class LocationNotFoundException extends ApiException {
  const LocationNotFoundException({
    super.message = 'Location not found. Please try a different search.',
    super.statusCode,
    super.stackTrace,
  });
}

/// Exception thrown when weather data is not available
class WeatherDataNotFoundException extends ApiException {
  const WeatherDataNotFoundException({
    super.message = 'Weather data not available for this location.',
    super.statusCode,
    super.stackTrace,
  });
}

/// Exception for location request failure (kept for backward compatibility)
class LocationRequestFailure implements Exception {}

/// Exception for location not found failure (kept for backward compatibility)
class LocationNotFoundFailure implements Exception {}

/// Exception for weather request failure (kept for backward compatibility)
class WeatherRequestFailure implements Exception {}

/// Exception for weather not found failure (kept for backward compatibility)
class WeatherNotFoundFailure implements Exception {}
