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
          final hourlyForecast = state.weather.hourly;

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<WeatherCubit>().refreshWeather();
            },
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              itemCount: hourlyForecast.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final item = hourlyForecast[index];
                final date = DateTime.parse(item.time);
                final time = DateFormat('HH:mm').format(date);
                final day = DateFormat('MM/dd').format(date);

                return ListTile(
                  leading: Text(
                    item.condition.toEmoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                  title: Text(
                    time,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    day,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: Text(
                    '${item.temperature.value.toStringAsFixed(1)}°',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
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
