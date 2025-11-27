import 'package:flutter_sample/pages/favorites/models/favorite_location.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:weather_repository/weather_repository.dart';

class FavoritesState {
  FavoritesState({
    required this.favorites,
    required this.weatherByLocation,
    this.isLoading = false,
  });

  factory FavoritesState.fromJson(Map<String, dynamic> json) {
    return FavoritesState(
      favorites: (json['favorites'] as List<dynamic>)
          .map((e) => FavoriteLocation.fromJson(e as Map<String, dynamic>))
          .toList(),
      weatherByLocation:
          (json['weatherByLocation'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, Weather.fromJson(v as Map<String, dynamic>)),
          ) ??
          {},
    );
  }

  final List<FavoriteLocation> favorites;
  final Map<String, Weather> weatherByLocation;
  final bool isLoading;

  FavoritesState copyWith({
    List<FavoriteLocation>? favorites,
    Map<String, Weather>? weatherByLocation,
    bool? isLoading,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      weatherByLocation: weatherByLocation ?? this.weatherByLocation,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'favorites': favorites.map((e) => e.toJson()).toList(),
      'weatherByLocation': weatherByLocation.map(
        (k, v) => MapEntry(k, v.toJson()),
      ),
    };
  }
}

class FavoritesCubit extends HydratedCubit<FavoritesState> {
  FavoritesCubit(this.weatherRepository)
    : super(FavoritesState(favorites: [], weatherByLocation: {}));

  final WeatherRepository weatherRepository;

  Future<void> loadWeatherForFavorites() async {
    emit(state.copyWith(isLoading: true));

    final results = <String, Weather>{};
    for (final location in state.favorites) {
      final weather = await weatherRepository.getWeatherByCoordinates(
        latitude: double.parse(location.latitude),
        longitude: double.parse(location.longitude),
        locationName: location.name,
      );
      results[location.name] = weather;
    }
    emit(state.copyWith(weatherByLocation: results, isLoading: false));
  }

  void addFavorite(FavoriteLocation location) {
    final updated = [...state.favorites, location];
    emit(state.copyWith(favorites: updated));
  }

  void removeFavorite(String name) {
    final updated = state.favorites.where((l) => l.name != name).toList();
    emit(state.copyWith(favorites: updated));
  }

  @override
  FavoritesState? fromJson(Map<String, dynamic> json) {
    return FavoritesState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(FavoritesState state) {
    return state.toJson();
  }
}
