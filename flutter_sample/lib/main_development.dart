import 'package:flutter_sample/app/app.dart';
import 'package:flutter_sample/bootstrap.dart';

/// Main entry point for development environment
Future<void> main() async {
  await bootstrap(() => const WeatherApp());
}
