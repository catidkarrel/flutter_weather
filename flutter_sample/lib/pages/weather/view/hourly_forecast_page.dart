import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/pages/weather/cubit/weather_cubit.dart';
import 'package:intl/intl.dart';
import 'package:weather_repository/weather_repository.dart';

class HourlyForecastPage extends StatelessWidget {
  const HourlyForecastPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HourlyForecastPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hourly Forecast')),
      body: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (context, state) {
          final now = DateTime.now();
          final hourlyForecast = state.weather.hourly
              .where((item) {
                final date = DateTime.parse(item.time);
                return date.isAfter(now.subtract(const Duration(hours: 1)));
              })
              .take(24)
              .toList();

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<WeatherCubit>().refreshWeather();
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: 200,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
                    ),
                    itemCount: hourlyForecast.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 32),
                    itemBuilder: (context, index) {
                      final item = hourlyForecast[index];
                      final date = DateTime.parse(item.time);
                      final time = DateFormat('HH:mm').format(date);
                      final day = DateFormat('MM/dd').format(date);

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            day,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            time,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            item.condition.toEmoji,
                            style: const TextStyle(fontSize: 40),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${item.temperature.value.toStringAsFixed(1)}°',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

extension on WeatherCondition {
  String get toEmoji {
    switch (this) {
      case WeatherCondition.clear:
        return '☀️';
      case WeatherCondition.rainy:
        return '🌧️';
      case WeatherCondition.cloudy:
        return '☁️';
      case WeatherCondition.snowy:
        return '🌨️';
      case WeatherCondition.unknown:
        return '❓';
    }
  }
}
