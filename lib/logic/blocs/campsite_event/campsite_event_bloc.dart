import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_camp/data/models/campsite_event_model.dart';
import 'package:my_camp/data/repository/campsite_event_repository.dart';

part 'campsite_event_event.dart';
part 'campsite_event_state.dart';

class CampsiteEventBloc extends Bloc<CampsiteEventEvent, CampsiteEventState> {
  final CampsiteEventRepository campsiteEventRepository;
  CampsiteEventBloc({required this.campsiteEventRepository})
      : super(CampsiteEventInitial()) {
    on<CampsiteEventsRequested>((event, emit) async {
      emit(CampsiteEventsLoading());
      try {
        final campsiteEvents =
            await campsiteEventRepository.getCampsiteEvents(event.campsiteId);
        emit(CampsiteEventsLoaded(campsiteEvents: campsiteEvents));
      } catch (e) {
        emit(CampsiteEventsError(error: e.toString()));
      }
    });
    on<CampsiteEventAdd>((event, emit) async {
      emit(CampsiteEventsLoading());
      try {
        final campsiteEvent = CampsiteEventModel(
          name: event.name,
          startDate: event.startDate,
          endDate: event.endDate,
          price: event.price,
          campsiteId: event.campsiteId,
        );
        await campsiteEventRepository.add(campsiteEvent);
        emit(CampsiteEventAdded());
      } catch (e) {
        emit(CampsiteEventsError(error: e.toString()));
      }
    });

    on<CampsiteEventDelete>((event, emit) async {
      // emit(CampsiteEventsLoading());
      try {
        await campsiteEventRepository.delete(event.campsiteEventId);
        emit(CampsiteEventDeleted());
      } catch (e) {
        emit(CampsiteEventsError(error: e.toString()));
      }
    });

     on<SingleCampsiteEventRequested>((event, emit) async {
      emit(SingleCampsiteEventLoading());
      try {
        final campsiteEvent = await campsiteEventRepository.getSingleCampsiteEvent(event.campsiteEventId);
        emit(SingleCampsiteEventLoaded(campsiteEvent: campsiteEvent!));
      } catch (e) {
        emit(SingleCampsiteEventError(error: e.toString()));
      }
    });

    on<CampsiteEventSelected>((event, emit) {
      emit(SelectedCampsiteEvent(
          campsiteEvents: event.campsiteEvents,
          selectedIndex: event.selectedIndex));
    });
  }
}
