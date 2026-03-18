import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/pages/weather/cubit/weather_cubit.dart';
import 'package:flutter_sample/pages/weather/models/weather.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_repository/weather_repository.dart' hide Weather;

class AthleteCastPage extends StatelessWidget {
  const AthleteCastPage({super.key});

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF121624);
    const greenAccent = Color(0xFF00E676);
    const subTextColor = Color(0xFF8A93A6);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: BlocBuilder<WeatherCubit, WeatherState>(
          builder: (context, state) {
            if (state.status == WeatherStatus.initial) {
              return Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final location = await context.push('/weather/search');
                    if (!context.mounted) return;
                    if (location != null) {
                      await context.read<WeatherCubit>().fetchWeatherByLocation(
                        location as Location,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: greenAccent,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Search Location'),
                ),
              );
            }
            if (state.status == WeatherStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(color: greenAccent),
              );
            }
            // we will show last known weather for error as well
            return _AthletePopulated(
              weather: state.weather,
              units: state.temperatureUnits,
            );
          },
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF161A28),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: greenAccent,
          unselectedItemColor: subTextColor,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.home_filled),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.calendar_today),
              ),
              label: 'Schedule',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.bar_chart),
              ),
              label: 'Stats',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.tune),
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

class _AthletePopulated extends StatelessWidget {
  const _AthletePopulated({required this.weather, required this.units});

  final Weather weather;
  final TemperatureUnits units;

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF1E2333);
    const greenAccent = Color(0xFF00E676);
    const yellowAccent = Color(0xFFFFD54F);
    const redAccent = Color(0xFFE57373);
    const cyanAccent = Color(0xFF00E5FF);
    const textColor = Colors.white;
    const subTextColor = Color(0xFF8A93A6);

    final conditionName = weather.condition.name.toUpperCase();
    final temperatureValue = weather.temperature.value.toStringAsFixed(0);
    final isCelsius = units.isCelsius;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                      children: [
                        TextSpan(
                          text: 'Athlete',
                          style: TextStyle(color: textColor),
                        ),
                        TextSpan(
                          text: 'Cast',
                          style: TextStyle(color: greenAccent),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    weather.location,
                    style: const TextStyle(
                      color: subTextColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const CircleAvatar(
                backgroundColor: cardColor,
                radius: 22,
                child: Icon(
                  Icons.person_outline,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Weather Card
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: greenAccent.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            conditionName,
                            style: TextStyle(
                              color: greenAccent.withOpacity(0.9),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$temperatureValue°',
                              style: const TextStyle(
                                color: textColor,
                                fontSize: 64,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                isCelsius ? 'C' : 'F',
                                style: const TextStyle(
                                  color: subTextColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Icon(
                      weather.condition.toIconEmoji,
                      color: Colors.white,
                      size: 80,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Divider(
                  color: subTextColor.withOpacity(0.2),
                  thickness: 1,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildWeatherDetail(
                      'WIND',
                      weather.windSpeed != null
                          ? '${weather.windSpeed!.toStringAsFixed(1)} mph'
                          : 'N/A',
                      textColor,
                      subTextColor,
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: subTextColor.withOpacity(0.2),
                    ),
                    _buildWeatherDetail(
                      'HUMIDITY',
                      '12%', // Display static value as humidity isn't in API yet
                      textColor,
                      subTextColor,
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: subTextColor.withOpacity(0.2),
                    ),
                    _buildWeatherDetail(
                      'UV INDEX',
                      'High 7', // Display static value as UV index isn't in API yet
                      const Color(0xFFFF9800),
                      subTextColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Training Outlook Header
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Training Outlook',
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Next 24 Hours',
                style: TextStyle(
                  color: cyanAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Activities List
          _buildActivityCard(
            icon: Icons.bolt,
            title: 'Running',
            subtitle: weather.temperature.value > 85
                ? 'High temp, run early'
                : 'Mild temp, ideal conditions',
            status: weather.temperature.value > 85 ? 'CAUTION' : 'OPTIMAL',
            statusColor: weather.temperature.value > 85
                ? yellowAccent
                : greenAccent,
            cardColor: cardColor,
            textColor: textColor,
            subTextColor: subTextColor,
          ),
          const SizedBox(height: 16),
          _buildActivityCard(
            icon: Icons.directions_bike,
            title: 'Cycling',
            subtitle: weather.windSpeed != null && weather.windSpeed! > 10
                ? 'Moderate crosswinds (${weather.windSpeed!.toStringAsFixed(1)}mph)'
                : 'Good wind conditions',
            status: weather.windSpeed != null && weather.windSpeed! > 10
                ? 'CAUTION'
                : 'OPTIMAL',
            statusColor: weather.windSpeed != null && weather.windSpeed! > 10
                ? yellowAccent
                : greenAccent,
            cardColor: cardColor,
            textColor: textColor,
            subTextColor: subTextColor,
          ),
          const SizedBox(height: 16),
          _buildActivityCard(
            icon: Icons.waves,
            title: 'Open Water',
            subtitle: conditionName == 'RAINY' || conditionName == 'SNOWY'
                ? 'Poor visibility and risk'
                : 'Clear conditions',
            status: conditionName == 'RAINY' || conditionName == 'SNOWY'
                ? 'POOR'
                : 'OPTIMAL',
            statusColor: conditionName == 'RAINY' || conditionName == 'SNOWY'
                ? redAccent
                : greenAccent,
            cardColor: cardColor,
            textColor: textColor,
            subTextColor: subTextColor,
          ),
          const SizedBox(height: 32),

          // Plan Workout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: cyanAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'PLAN WORKOUT',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.add_circle, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(
    String label,
    String value,
    Color valueColor,
    Color subTextColor,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: subTextColor,
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String status,
    required Color statusColor,
    required Color cardColor,
    required Color textColor,
    required Color subTextColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.05),
            offset: const Offset(-4, 0),
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: statusColor,
                width: 4,
              ),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bgColorForStatus(statusColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: statusColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: subTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color bgColorForStatus(Color statusColor) {
    if (statusColor == const Color(0xFF00E676)) return const Color(0xFF1E3A33);
    if (statusColor == const Color(0xFFFFD54F)) return const Color(0xFF333022);
    if (statusColor == const Color(0xFFE57373)) return const Color(0xFF3B2326);
    return Colors.transparent;
  }
}

extension on WeatherCondition {
  IconData get toIconEmoji {
    switch (this) {
      case WeatherCondition.clear:
        return Icons.wb_sunny;
      case WeatherCondition.rainy:
        return Icons.wb_cloudy_rounded;
      case WeatherCondition.cloudy:
        return Icons.wb_cloudy;
      case WeatherCondition.snowy:
        return Icons.wb_cloudy_sharp;
      case WeatherCondition.unknown:
        return Icons.wb_sunny;
    }
  }
}
