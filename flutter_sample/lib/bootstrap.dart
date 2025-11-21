import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sample/flavor_config.dart';

/// Bloc observer for handling bloc events
class WeatherBlocObserver extends BlocObserver {
  const WeatherBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

/// Bootstrap function for initializing app
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const WeatherBlocObserver();

  /// Add cross-flavor configuration here
  const flavor = String.fromEnvironment('FLAVOR');
  var configPath = 'assets/config/dev.json'; // default

  switch (flavor) {
    case 'staging':
      configPath = 'assets/config/staging.json';
    case 'production':
      configPath = 'assets/config/prod.json';
    case 'development':
    default:
      configPath = 'assets/config/dev.json';
  }

  await FlavorConfig.load(configPath);

  runApp(await builder());
}
