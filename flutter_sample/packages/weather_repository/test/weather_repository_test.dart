import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:open_meteo_api/open_meteo_api.dart' as open_meteo_api;
import 'package:weather_repository/location_repository.dart';
import 'package:weather_repository/weather_repository.dart';

class MockOpenMeteoApiClient extends Mock
    implements open_meteo_api.OpenMeteoApiClient {}

class MockLocationRepository extends Mock implements LocationRepository {}

void main() {
  group('WeatherRepository', () {
    late open_meteo_api.OpenMeteoApiClient weatherApiClient;
    late LocationRepository locationRepository;
    late WeatherRepository weatherRepository;

    setUp(() {
      weatherApiClient = MockOpenMeteoApiClient();
      locationRepository = MockLocationRepository();
      weatherRepository = WeatherRepository(
        weatherApiClient: weatherApiClient,
        locationRepository: locationRepository,
        baseUrlWeather: 'weather',
        baseUrlGeocoding: 'geocoding',
      );
    });

    test('getWeather returns weather with daily forecast', () async {
      final location = open_meteo_api.Location(
        id: 1,
        name: 'London',
        latitude: 51.5074,
        longitude: -0.1278,
        country: 'UK',
        admin1: 'England',
      );
      final weather = open_meteo_api.Weather(
        temperature: 15,
        weatherCode: 0,
        daily: [
          open_meteo_api.DailyForecast(
            date: '2023-01-01',
            weatherCode: 0,
            maxTemp: 20,
            minTemp: 10,
          ),
        ],
      );

      when(
        () => weatherApiClient.locationSearch(any()),
      ).thenAnswer((_) async => location);
      when(
        () => weatherApiClient.getWeather(
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
        ),
      ).thenAnswer((_) async => weather);

      final result = await weatherRepository.getWeather('London');

      expect(result.daily, isNotEmpty);
      expect(result.daily.first.date, '2023-01-01');
      expect(result.daily.first.maxTemp, 20);
      expect(result.daily.first.minTemp, 10);
    });
  });
}
