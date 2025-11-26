import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/pages/favorites/cubit/favorites_cubit.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        if (state.isLoading && state.weatherByLocation.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return RefreshIndicator(
          onRefresh: () => context.read<FavoritesCubit>().loadWeatherForFavorites(),
          child: ListView.builder(
            itemCount: state.favorites.length,
            itemBuilder: (context, index) {
              final location = state.favorites[index];
              final weather = state.weatherByLocation[location.name];
              
              if (weather == null) {
                return ListTile(
                  title: Text(location.name),
                  subtitle: const Text('Loading...'),
                );
              }

              return ListTile(
                title: Text(location.name),
                subtitle: Text(
                  'Temp: ${weather.temperature}°C • ${weather.condition.name}'
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () => 
                    context.read<FavoritesCubit>().removeFavorite(location.name),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
