import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/pages/favorites/cubit/favorites_cubit.dart';
import 'package:flutter_sample/pages/favorites/models/favorite_location.dart';
import 'package:flutter_sample/pages/search/view/search_page.dart';
import 'package:flutter_sample/pages/settings/view/settings_page.dart';
import 'package:flutter_sample/pages/weather/cubit/weather_cubit.dart';
import 'package:flutter_sample/pages/weather/widgets/widgets.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      /// App bar with settings and favorites buttons
      appBar: AppBar(
        actions: [
          BlocBuilder<WeatherCubit, WeatherState>(
            builder: (context, state) {
              if (state.status == WeatherStatus.success) {
                return BlocBuilder<FavoritesCubit, FavoritesState>(
                  builder: (context, favoritesState) {
                    final isFavorite = favoritesState.favorites.any(
                      (location) => location.name == state.weather.location,
                    );
                    return IconButton(
                      icon: const Icon(Icons.favorite),
                      onPressed: isFavorite
                          ? null
                          : () {
                              context.read<FavoritesCubit>().addFavorite(
                                FavoriteLocation(
                                  name: state.weather.location,
                                  latitude: state.weather.latitude,
                                  longitude: state.weather.longitude,
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Added to favorites'),
                                ),
                              );
                            },
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push<void>(
              /// Route to settings page
              SettingsPage.route(),
            ),
          ),
        ],
      ),

      /// Body of weather page
      body: Center(
        child: BlocBuilder<WeatherCubit, WeatherState>(
          builder: (context, state) {
            return switch (state.status) {
              WeatherStatus.initial => const WeatherEmpty(),
              WeatherStatus.loading => const WeatherLoading(),
              WeatherStatus.failure => const WeatherError(),
              WeatherStatus.success => WeatherPopulated(
                weather: state.weather,
                units: state.temperatureUnits,
                onRefresh: () {
                  return context.read<WeatherCubit>().refreshWeather();
                },
              ),
            };
          },
        ),
      ),

      /// Floating action button for searching city
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search, semanticLabel: 'Search'),
        onPressed: () async {
          final location = await Navigator.of(context).push(
            SearchPage.route(),
          );
          if (!context.mounted) return;
          if (location != null) {
            await context.read<WeatherCubit>().fetchWeatherByLocation(location);
          }
        },
      ),
    );
  }
}
