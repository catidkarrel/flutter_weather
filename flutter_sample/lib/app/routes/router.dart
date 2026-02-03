import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/pages/favorites/cubit/favorites_cubit.dart';
import 'package:flutter_sample/pages/favorites/view/favorites_page.dart';
import 'package:flutter_sample/pages/search/view/search_page.dart';
import 'package:flutter_sample/pages/settings/view/settings_page.dart';
import 'package:flutter_sample/pages/splash/splash.dart';
import 'package:flutter_sample/pages/weather/cubit/weather_cubit.dart';
import 'package:flutter_sample/pages/weather/view/forecast_page.dart';
import 'package:flutter_sample/pages/weather/view/hourly_forecast_page.dart';
import 'package:flutter_sample/pages/weather/view/weather_page.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> _weatherNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'weather');

class AppRouter {
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
        redirect: (context, state) async {
          // You might ideally want to delay here or check initialization state
          // but since GoRouter redirect is synchronous or simple async,
          // usually splash logic is handled by a state listener or a wrapper.
          // For now, we'll mimic the delay and then forward.
          // However, putting a delay in redirect is bad practice.
          // Better: The SplashPage itself should navigate after delay.
          return null;
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _weatherNavigatorKey,
            routes: [
              GoRoute(
                path: '/weather',
                builder: (context, state) => const WeatherPage(),
                routes: [
                  GoRoute(
                    path: 'search',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const SearchPage(),
                  ),
                  GoRoute(
                    path: 'forecast',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const ForecastPage(),
                  ),
                  GoRoute(
                    path: 'hourly',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const HourlyForecastPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/favorites',
                builder: (context, state) => FavoritesPage(
                  onLocationSelected: (locationName) async {
                    await context.read<WeatherCubit>()
                        .fetchWeather(locationName);
                    context.go('/weather');
                  },
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => _onTap(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Weather',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Future<void> _onTap(BuildContext context, int index) async {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );

    // Logic from original App.dart
    if (index == 1) {
      await context.read<FavoritesCubit>().loadWeatherForFavorites();
    }
  }
}
