import 'dart:async';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_meteo_api/open_meteo_api.dart';

class MockAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (options.path.contains('forecast')) {
      return ResponseBody.fromString(
        '''
        {
          "current": {
            "temperature_2m": 15.0,
            "apparent_temperature": 14.0,
            "wind_speed_10m": 10.0,
            "wind_direction_10m": 180.0,
            "weather_code": 1.0
          },
          "daily": {
            "time": ["2023-01-01", "2023-01-02"],
            "weather_code": [1.0, 2.0],
            "temperature_2m_max": [20.0, 22.0],
            "temperature_2m_min": [10.0, 12.0]
          }
        }
        ''',
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }
    throw UnimplementedError();
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  group('OpenMeteoApiClient', () {
    late OpenMeteoApiClient apiClient;
    late Dio dio;

    setUp(() {
      dio = Dio();
      dio.httpClientAdapter = MockAdapter();
      apiClient = OpenMeteoApiClient(
        dioClient: dio,
        aBaseUrlWeather: 'api.open-meteo.com',
        aBaseUrlGeocoding: 'geocoding-api.open-meteo.com',
      );
    });

    test('getWeather returns daily forecast', () async {
      final weather = await apiClient.getWeather(latitude: 0, longitude: 0);
      expect(weather.daily, isNotEmpty);
      expect(weather.daily.length, 2);
      expect(weather.daily.first.date, '2023-01-01');
      expect(weather.daily.first.maxTemp, 20.0);
    });
  });
}
