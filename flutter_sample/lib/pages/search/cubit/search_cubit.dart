import 'package:bloc/bloc.dart';
import 'package:flutter_sample/pages/search/cubit/search_state.dart';
import 'package:weather_repository/weather_repository.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._weatherRepository) : super(const SearchState());

  final WeatherRepository _weatherRepository;

  Future<void> search(String query) async {
    if (query.isEmpty) {
      emit(const SearchState());
      return;
    }

    emit(state.copyWith(status: SearchStatus.loading));

    try {
      final results = await _weatherRepository.searchLocations(query);
      emit(
        state.copyWith(
          status: SearchStatus.success,
          results: results,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SearchStatus.failure,
          errorMessage: 'Something went wrong',
        ),
      );
    }
  }
}
