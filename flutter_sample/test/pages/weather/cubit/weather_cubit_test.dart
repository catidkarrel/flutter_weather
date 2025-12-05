import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_sample/pages/weather/cubit/weather_cubit.dart';
import 'package:flutter_sample/pages/weather/models/weather.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_repository/weather_repository.dart'
    as weather_repository;

class MockWeatherRepository extends Mock
    implements weather_repository.WeatherRepository {}

class MockStorage extends Mock implements Storage {}

void main() {
  group('WeatherCubit', () {
    late weather_repository.WeatherRepository weatherRepository;
    late WeatherCubit weatherCubit;
    late Storage storage;

    setUp(() {
      storage = MockStorage();
      when(() => storage.write(any(), any())).thenAnswer((_) async {});
      when(() => storage.read(any())).thenReturn(null);
      HydratedBloc.storage = storage;

      weatherRepository = MockWeatherRepository();
      weatherCubit = WeatherCubit(weatherRepository);
    });

    test('initial state is correct', () {
      expect(weatherCubit.state, WeatherState());
    });

    blocTest<WeatherCubit, WeatherState>(
      'emits [loading, success] when fetchWeather returns weather with daily forecast',
      setUp: () {
        const weather = weather_repository.Weather(
          location: 'London',
          temperature: 15,
          condition: weather_repository.WeatherCondition.clear,
          latitude: '51.5',
          longitude: '-0.1',
          daily: [
            weather_repository.DailyForecast(
              date: '2023-01-01',
              condition: weather_repository.WeatherCondition.clear,
              maxTemp: 20,
              minTemp: 10,
            ),
          ],
        );
        when(
          () => weatherRepository.getWeather(any()),
        ).thenAnswer((_) async => weather);
      },
      build: () => weatherCubit,
      act: (cubit) => cubit.fetchWeather('London'),
      expect: () => [
        isA<WeatherState>().having(
          (s) => s.status,
          'status',
          WeatherStatus.loading,
        ),
        isA<WeatherState>()
            .having((s) => s.status, 'status', WeatherStatus.success)
            .having((s) => s.weather.daily, 'daily', isNotEmpty)
            .having(
              (s) => s.weather.daily.first.maxTemp.value,
              'maxTemp',
              20.0,
            ),
      ],
    );
  });
}
