import 'package:equatable/equatable.dart';
import 'package:flutter_sample/pages/weather/weather.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weather_repository/weather_repository.dart'
    show WeatherRepository, Location;

part 'weather_cubit.g.dart';
part 'weather_state.dart';

/// Class definition for weather cubit that extends HydratedCubit
class WeatherCubit extends HydratedCubit<WeatherState> {
  /// Constructor for weather cubit
  WeatherCubit(this._weatherRepository) : super(WeatherState());

  /// Weather repository
  final WeatherRepository _weatherRepository;

  /// Fetch weather for a city
  Future<void> fetchWeather(String? city) async {
    if (city == null || city.isEmpty) return;

    emit(state.copyWith(status: WeatherStatus.loading));

    try {
      final weather = Weather.fromRepository(
        await _weatherRepository.getWeather(city),
      );
      final units = state.temperatureUnits;
      final value = units.isFahrenheit
          ? weather.temperature.value.toFahrenheit()
          : weather.temperature.value;

      emit(
        state.copyWith(
          status: WeatherStatus.success,
          temperatureUnits: units,
          weather: weather.copyWith(
            temperature: Temperature(value: value),
          ),
        ),
      );
    } on Exception {
      emit(state.copyWith(status: WeatherStatus.failure));
    }
  }

  /// Fetch weather for a location
  Future<void> fetchWeatherByLocation(Location location) async {
    emit(state.copyWith(status: WeatherStatus.loading));

    try {
      final weather = Weather.fromRepository(
        await _weatherRepository.getWeatherByCoordinates(
          latitude: location.latitude,
          longitude: location.longitude,
          locationName: location.name,
        ),
      );
      final units = state.temperatureUnits;
      final value = units.isFahrenheit
          ? weather.temperature.value.toFahrenheit()
          : weather.temperature.value;

      emit(
        state.copyWith(
          status: WeatherStatus.success,
          temperatureUnits: units,
          weather: weather.copyWith(temperature: Temperature(value: value)),
        ),
      );
    } on Exception {
      emit(state.copyWith(status: WeatherStatus.failure));
    }
  }

  /// Refresh weather with the current location
  Future<void> refreshWeather() async {
    if (!state.status.isSuccess) return;
    if (state.weather == Weather.empty) return;
    try {
      final weather = Weather.fromRepository(
        await _weatherRepository.getWeatherByLocation(),
      );
      final units = state.temperatureUnits;
      final value = units.isFahrenheit
          ? weather.temperature.value.toFahrenheit()
          : weather.temperature.value;

      emit(
        state.copyWith(
          status: WeatherStatus.success,
          temperatureUnits: units,
          weather: weather.copyWith(temperature: Temperature(value: value)),
        ),
      );
    } on Exception {
      emit(state);
    }
  }

  /// Toggle temperature units
  void toggleUnits() {
    final units = state.temperatureUnits.isFahrenheit
        ? TemperatureUnits.celsius
        : TemperatureUnits.fahrenheit;

    if (!state.status.isSuccess) {
      emit(state.copyWith(temperatureUnits: units));
      return;
    }

    final weather = state.weather;
    if (weather != Weather.empty) {
      final temperature = weather.temperature;
      final value = units.isCelsius
          ? temperature.value.toCelsius()
          : temperature.value.toFahrenheit();
      emit(
        state.copyWith(
          temperatureUnits: units,
          weather: weather.copyWith(temperature: Temperature(value: value)),
        ),
      );
    }
  }

  /// JSON serialization for weather cubit
  @override
  WeatherState fromJson(Map<String, dynamic> json) =>
      WeatherState.fromJson(json);

  /// JSON deserialization for weather cubit
  @override
  Map<String, dynamic> toJson(WeatherState state) => state.toJson();
}

/// Extension for temperature conversion
extension TemperatureConversion on double {
  /// Convert temperature to Fahrenheit
  double toFahrenheit() => (this * 9 / 5) + 32;

  /// Convert temperature to Celsius
  double toCelsius() => (this - 32) * 5 / 9;
}
