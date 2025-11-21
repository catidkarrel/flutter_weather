import 'dart:convert';

import 'package:flutter/services.dart';

class FlavorConfig {

  FlavorConfig({
    required this.flavor,
    required this.baseUrlWeather,
    required this.baseUrlGeocoding,
    required this.enableLogs,
  });

  factory FlavorConfig.fromJson(Map<String, dynamic> json) {
    return FlavorConfig(
      flavor: json['flavor'] as String,
      baseUrlWeather: json['baseUrlWeather'] as String,
      baseUrlGeocoding: json['baseUrlGeocoding'] as String,
      enableLogs: json['enableLogs'] as bool,
    );
  }
  final String flavor;
  final String baseUrlWeather;
  final String baseUrlGeocoding;
  final bool enableLogs;

  static late FlavorConfig current;

  static Future<void> load(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    final jsonMap = json.decode(raw) as Map<String, dynamic>;
    current = FlavorConfig.fromJson(jsonMap);
  }
}
