import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/pages/search/cubit/cubit.dart';
import 'package:weather_repository/weather_repository.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  static Route<Location> route() {
    return MaterialPageRoute(builder: (_) => const SearchPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(context.read<WeatherRepository>()),
      child: const SearchView(),
    );
  }
}

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _textController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _textController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      unawaited(context.read<SearchCubit>().search(query));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('City Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _textController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                labelText: 'Search Location',
                hintText: 'Enter city name...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                // fillColor: Theme.of(context).inputDecorationTheme.fillColor, // Use default or theme
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state.status == SearchStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.status == SearchStatus.failure) {
                  return Center(child: Text(state.errorMessage ?? 'Error'));
                }
                if (state.results.isEmpty &&
                    _textController.text.isNotEmpty &&
                    state.status == SearchStatus.success) {
                  return const Center(child: Text('No results found'));
                }

                return ListView.builder(
                  itemCount: state.results.length,
                  itemBuilder: (context, index) {
                    final location = state.results[index];
                    final subtitle = [
                      location.region,
                      location.country,
                    ].where((e) => e != null && e.isNotEmpty).join(', ');

                    return ListTile(
                      title: Text(
                        location.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.of(context).pop(location);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
