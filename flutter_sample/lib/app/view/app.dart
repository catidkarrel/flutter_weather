import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/flavor_config.dart';
import 'package:flutter_sample/pages/favorites/cubit/favorites_cubit.dart';
import 'package:flutter_sample/pages/favorites/view/favorites_page.dart';
import 'package:flutter_sample/pages/settings/view/settings_page.dart';
import 'package:flutter_sample/pages/splash/splash.dart';
import 'package:flutter_sample/pages/weather/cubit/weather_cubit.dart';
import 'package:flutter_sample/pages/weather/view/weather_page.dart';
import 'package:flutter_sample/pages/weather/weather.dart';
import 'package:weather_repository/weather_repository.dart'
    show WeatherCondition, WeatherRepository;

/// Weather app
class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => WeatherRepository(
        baseUrlWeather: FlavorConfig.current.baseUrlWeather,
        baseUrlGeocoding: FlavorConfig.current.baseUrlGeocoding,
        enableLogs: FlavorConfig.current.enableLogs,
      ),
      dispose: (repository) => repository.dispose(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                WeatherCubit(context.read<WeatherRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                FavoritesCubit(context.read<WeatherRepository>()),
          ),
        ],
        child: const WeatherAppView(),
      ),
    );
  }
}

/// Weather app view
class WeatherAppView extends StatefulWidget {
  const WeatherAppView({super.key});

  @override
  State<WeatherAppView> createState() => _WeatherAppViewState();
}

class _WeatherAppViewState extends State<WeatherAppView>
    with WidgetsBindingObserver {
  int _selectedIndex = 0;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_initializeApp());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(context.read<WeatherCubit>().refreshWeather());
    }
  }

  Future<void> _initializeApp() async {
    // Show splash screen for minimum duration
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isInitialized = true);
    }
  }

  List<Widget> get _pages => [
    const WeatherPage(),
    FavoritesPage(
      onLocationSelected: (locationName) async {
        // Fetch weather for the selected location
        await context.read<WeatherCubit>().fetchWeather(locationName);
        // Navigate to weather page
        setState(() => _selectedIndex = 0);
      },
    ),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    // Load weather data when navigating to favorites page
    if (index == 1) {
      // Ignore the future since this is a fire-and-forget operation
      // ignore: discarded_futures
      context.read<FavoritesCubit>().loadWeatherForFavorites();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show splash screen during initialization
    if (!_isInitialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: FlavorConfig.current.enableLogs,
        home: const SplashPage(),
      );
    }

    final seedColor = context.select(
      (WeatherCubit cubit) => cubit.state.weather.toColor,
    );

    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
      ),
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: Scaffold(
          body: _pages[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
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
        ),
      ),
    );
  }
}

/// Extension for Weather class
extension on Weather {
  Color get toColor {
    switch (condition) {
      case WeatherCondition.clear:
        return Colors.yellow;
      case WeatherCondition.snowy:
        return Colors.lightBlueAccent;
      case WeatherCondition.cloudy:
        return Colors.blueGrey;
      case WeatherCondition.rainy:
        return Colors.indigoAccent;
      case WeatherCondition.unknown:
        return Colors.cyan;
    }
  }
}
