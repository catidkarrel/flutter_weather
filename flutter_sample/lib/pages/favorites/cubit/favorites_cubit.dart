import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/pages/favorites/models/favorite_location.dart';
import 'package:weather_repository/weather_repository.dart';

class FavoritesState {
  FavoritesState({
    required this.favorites,
    required this.weatherByLocation,
    this.isLoading = false,
  });
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
}

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit(this.weatherRepository) : super(FavoritesState(
    favorites: [], weatherByLocation: {}));

  final WeatherRepository weatherRepository;

  Future<void> loadWeatherForFavorites() async {
    emit(state.copyWith(isLoading: true));
    
    final results = <String, Weather>{};
    for (final location in state.favorites) {
      final weather = await weatherRepository.getWeather(
        location.name,
      );
      results[location.name] = weather;
    }
    emit(state.copyWith(
      weatherByLocation: results, 
      isLoading: false
    ));
  }

  void addFavorite(FavoriteLocation location) {
    final updated = [...state.favorites, location];
    emit(state.copyWith(favorites: updated));
  }

  void removeFavorite(String name) {
    final updated = state.favorites.where((l) => l.name != name).toList();
    emit(state.copyWith(favorites: updated));
  }
}
