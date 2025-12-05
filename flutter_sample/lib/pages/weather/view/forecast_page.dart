import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/pages/weather/cubit/weather_cubit.dart';
import 'package:intl/intl.dart';
import 'package:weather_repository/weather_repository.dart';

class ForecastPage extends StatelessWidget {
  const ForecastPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const ForecastPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('7-Day Forecast')),
      body: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (context, state) {
          final dailyForecast = state.weather.daily;

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<WeatherCubit>().refreshWeather();
            },
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              itemCount: dailyForecast.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final item = dailyForecast[index];
                final date = DateTime.parse(item.date);
                final formattedDate = DateFormat(
                  'EEEE, yyyy/MM/dd',
                ).format(date);

                return ListTile(
                  leading: Text(
                    item.condition.toEmoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                  title: Text(
                    formattedDate,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Max: ${item.maxTemp.value.toStringAsFixed(1)}°',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        'Min: ${item.minTemp.value.toStringAsFixed(1)}°',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
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
