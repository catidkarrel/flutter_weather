import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/app/routes/router.dart';
import 'package:flutter_sample/flavor_config.dart';
import 'package:flutter_sample/pages/favorites/cubit/favorites_cubit.dart';
import 'package:flutter_sample/pages/weather/cubit/weather_cubit.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<WeatherCubit>().refreshWeather();
    }
  }

  @override
  Widget build(BuildContext context) {
    final seedColor = context.select(
      (WeatherCubit cubit) => cubit.state.weather.toColor,
    );

    return MaterialApp.router(
      routerConfig: AppRouter.router,
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
