part of 'campsite_event_bloc.dart';

abstract class CampsiteEventState extends Equatable {
  const CampsiteEventState();

  @override
  List<Object> get props => [];
}

class CampsiteEventInitial extends CampsiteEventState {}

class CampsiteEventsLoading extends CampsiteEventState {}

class CampsiteEventsLoaded extends CampsiteEventState {
  final List<CampsiteEventModel> campsiteEvents;

  const CampsiteEventsLoaded({required this.campsiteEvents});

  @override
  List<Object> get props => [campsiteEvents];
}

class CampsiteEventAdded extends CampsiteEventState {}

class CampsiteEventDeleted extends CampsiteEventState {}

class CampsiteEventsError extends CampsiteEventState {
  final String error;

  const CampsiteEventsError({required this.error});

  @override
  List<Object> get props => [error];
}

class SingleCampsiteEventLoaded extends CampsiteEventState {
  final CampsiteEventModel campsiteEvent;

  const SingleCampsiteEventLoaded({required this.campsiteEvent});
  @override
  List<Object> get props => [campsiteEvent];
}

class SingleCampsiteEventLoading extends CampsiteEventState{}

class SingleCampsiteEventError extends CampsiteEventState{
  final String error;

  const SingleCampsiteEventError({required this.error});

  @override
  List<Object> get props => [error];
}

class SelectedCampsiteEvent extends CampsiteEventState {
  final List<CampsiteEventModel> campsiteEvents;
  final int selectedIndex;

  const SelectedCampsiteEvent(
      {required this.campsiteEvents, required this.selectedIndex});

  @override
  List<Object> get props => [campsiteEvents, selectedIndex];
}