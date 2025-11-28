import 'package:equatable/equatable.dart';
import 'package:weather_repository/weather_repository.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  const SearchState({
    this.status = SearchStatus.initial,
    this.results = const [],
    this.errorMessage,
  });

  final SearchStatus status;
  final List<Location> results;
  final String? errorMessage;

  SearchState copyWith({
    SearchStatus? status,
    List<Location>? results,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      results: results ?? this.results,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, results, errorMessage];
}
