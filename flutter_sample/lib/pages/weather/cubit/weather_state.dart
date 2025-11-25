part of 'weather_cubit.dart';

/// Enum definition for weather status
enum WeatherStatus { initial, loading, success, failure}

/// Extension for WeatherStatus
extension WeatherStatusX on WeatherStatus {
  bool get isInitial => this == WeatherStatus.initial;
  bool get isLoading => this == WeatherStatus.loading;
  bool get isSuccess => this == WeatherStatus.success;
  bool get isFailure => this == WeatherStatus.failure;
}

/// Class definition for weather state
@JsonSerializable()
final class WeatherState extends Equatable {
  /// Constructor for weather state
  WeatherState({
    this.status = WeatherStatus.initial,
    this.temperatureUnits = TemperatureUnits.celsius,
    Weather? weather,
  }) : weather = weather ?? Weather.empty;

  /// Factory constructor for weather state
  factory WeatherState.fromJson(Map<String, dynamic> json) 
    => _$WeatherStateFromJson(json);

  /// Status of weather
  final WeatherStatus status;
  /// Weather data
  final Weather weather;
  /// Temperature units
  final TemperatureUnits temperatureUnits;

  /// Copy with method for weather state
  WeatherState copyWith({
    WeatherStatus? status,
    TemperatureUnits? temperatureUnits,
    Weather? weather
  }) {
    return WeatherState(
      status: status ?? this.status,
      temperatureUnits: temperatureUnits ?? this.temperatureUnits,
      weather: weather ?? this.weather
    );
  }

  /// JSON serialization for weather state
  Map<String, dynamic> toJson() => _$WeatherStateToJson(this);

  /// Props definition for weather state
  @override
  List<Object?> get props => [status, temperatureUnits, weather];
}
