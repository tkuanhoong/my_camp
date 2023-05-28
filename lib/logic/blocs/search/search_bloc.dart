import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_camp/data/models/campsite.dart';
import 'package:my_camp/data/repository/campsite_repository.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final CampsiteRepository repository;
  SearchBloc({required this.repository}) : super(SearchInitial()) {
    // on<CampsitesRequested>((event, emit) async {
    //   if (event.firstLoad) {
    //     emit(SearchLoading());
    //   }
    //   try {
    //     List<Campsite> campsites = await repository.getCampsiteList(
    //         event.campsitesList, event.keyword, event.selectedStates);
    //     if (campsites.isEmpty) {
    //       emit(SearchResultLoaded(campsites, true));
    //     } else {
    //       emit(SearchResultLoaded(campsites, false));
    //     }
    //   } catch (error) {
    //     emit(SearchError(error.toString()));
    //   }
    // }, transformer: droppable());

    on<CampsitesRequested>((event, emit) async {
      if (event.firstLoad) {
        emit(SearchLoading());
      }
      try {
        List selectedStates = [];
        bool searchAction = false;
        if (event.selectedStates != null && event.selectedStates!.isNotEmpty) {
          selectedStates = event.selectedStates!
              .where((element) => element['isChecked'] == true)
              .map((e) => e['state'].toUpperCase())
              .toList();
        }

        List<Campsite> campsites = await repository.getCampsiteList(
            event.campsitesList, event.keyword, selectedStates, event.userId);
        if(event.keyword!.isNotEmpty || selectedStates.isNotEmpty){
          searchAction = true;
        }
        if (campsites.isEmpty) {
          emit(SearchResultLoaded(campsites, true, searchAction: searchAction));
        } else {
          emit(SearchResultLoaded(campsites, false, searchAction: searchAction));
        }
      } catch (error) {
        emit(SearchError(error.toString()));
      }
    }, transformer: droppable());
  }
}
