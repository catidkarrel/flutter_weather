import 'package:flutter_sample/app/app.dart';
import 'package:flutter_sample/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const WeatherApp());
}
