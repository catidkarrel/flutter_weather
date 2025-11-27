import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sample/flavor_config.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weather_repository/location_repository.dart';

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

/// Entrypoint of the app
/// Bootstrap function for initializing app
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialization process like location permission,
  // app config can be done here

  final locationRepository = LocationRepository();

  try {
    await locationRepository.initLocationPermission();
    log('Location permission granted');
  } on Exception {
    log('Location permission denied');
  }

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const WeatherBlocObserver();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory(
            (await getApplicationDocumentsDirectory()).path,
          ),
  );

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
