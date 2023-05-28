part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class CampsitesRequested extends SearchEvent {
  final List<Campsite> campsitesList;
  final bool firstLoad;
  final String? keyword;
  final List? selectedStates;
  final String? userId;
  const CampsitesRequested(
      {required this.campsitesList,
      this.firstLoad = false,
      this.keyword,
      this.selectedStates,
      this.userId});
  @override
  List<Object?> get props =>
      [campsitesList, firstLoad, keyword, selectedStates, userId];
}

// class SearchQueryChanged extends SearchEvent {
//   final List<Campsite> campsitesList;
//   final String? keyword;
//   final List? selectedStates;

//   const SearchQueryChanged({required this.campsitesList, this.keyword, this.selectedStates});
//   @override
//   List<Object?> get props => [keyword,selectedStates];
// }
