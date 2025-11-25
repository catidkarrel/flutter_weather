import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/flavor_config.dart';
import 'package:flutter_sample/search/view/search_page.dart';
import 'package:flutter_sample/settings/view/settings_page.dart';
import 'package:flutter_sample/weather/cubit/weather_cubit.dart';
import 'package:flutter_sample/weather/view/weather_page.dart';
import 'package:flutter_sample/weather/weather.dart';
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
        enableLogs: FlavorConfig.current.enableLogs
      ),
      dispose: (repository) => repository.dispose(),
      child: BlocProvider(
        create: (context) => WeatherCubit(context.read<WeatherRepository>()),
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

class _WeatherAppViewState extends State<WeatherAppView> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    WeatherPage(),
    Placeholder(color: Colors.blueAccent),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final seedColor = context.select(
      (WeatherCubit cubit) => cubit.state.weather.toColor,
    );

    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
      ),
      home: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud),
              label: 'Weather',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.radar),
              label: 'Radar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
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
