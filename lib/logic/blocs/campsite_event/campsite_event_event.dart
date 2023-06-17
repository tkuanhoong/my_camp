part of 'campsite_event_bloc.dart';

abstract class CampsiteEventEvent extends Equatable {
  const CampsiteEventEvent();

  @override
  List<Object> get props => [];
}

class CampsiteEventsRequested extends CampsiteEventEvent {
  final String campsiteId;

  const CampsiteEventsRequested({required this.campsiteId});

  @override
  List<Object> get props => [campsiteId];
}

class CampsiteEventAdd extends CampsiteEventEvent {
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final int price;
  final String campsiteId;

  const CampsiteEventAdd(
      {required this.name,
      required this.startDate,
      required this.endDate,
      required this.price,
      required this.campsiteId});

  @override
  List<Object> get props => [name, startDate, endDate, price, campsiteId];
}

class CampsiteEventDelete extends CampsiteEventEvent {
  final String campsiteEventId;

  const CampsiteEventDelete(this.campsiteEventId);

  @override
  List<Object> get props => [campsiteEventId];
}

class SingleCampsiteEventRequested extends CampsiteEventEvent {
  final String campsiteEventId;
  const SingleCampsiteEventRequested(this.campsiteEventId);

  @override
  List<Object> get props => [campsiteEventId];
}

class CampsiteEventSelected extends CampsiteEventEvent {
  final List<CampsiteEventModel> campsiteEvents;
  final int selectedIndex;
  const CampsiteEventSelected({required this.campsiteEvents, required this.selectedIndex});

  @override
  List<Object> get props => [campsiteEvents,selectedIndex];
}
