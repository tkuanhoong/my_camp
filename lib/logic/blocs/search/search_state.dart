part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  
  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchResultLoaded extends SearchState{
  final List<Campsite> searchResults;
  final bool hasReachedMax;
  final bool searchAction;

  const SearchResultLoaded(this.searchResults, this.hasReachedMax, {required this.searchAction});
  
  @override
  List<Object> get props => [searchResults, hasReachedMax, searchAction];
}

class SearchError extends SearchState {
  final String error;

  const SearchError(this.error);
  @override
  List<Object> get props => [error];
}

