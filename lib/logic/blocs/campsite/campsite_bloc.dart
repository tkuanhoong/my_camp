import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_camp/data/models/campsite.dart';
import 'package:my_camp/data/repository/campsite_repository.dart';

part 'campsite_event.dart';
part 'campsite_state.dart';

class CampsiteBloc extends Bloc<CampsiteEvent, CampsiteState> {
  CampsiteRepository campsiteRepository = CampsiteRepository();
  CampsiteBloc() : super(CampsiteInitial()) {
    on<SingleCampsiteRequested>((event, emit) async {
      emit(CampsiteLoading());
      try {
        Campsite? campsite = await campsiteRepository.fetchSingleCampsiteData(
            event.campsiteId, event.userId);
        if (campsite != null) {
          bool isCampsiteOwner = await campsiteRepository.verifyCampsiteOwner(
              event.userId, event.campsiteId);
          emit(CampsiteLoaded(
              campsite: campsite, isCampsiteOwner: isCampsiteOwner));
        }
      } catch (e) {
        emit(CampsiteError(error: e.toString()));
      }
    });
  }
}
