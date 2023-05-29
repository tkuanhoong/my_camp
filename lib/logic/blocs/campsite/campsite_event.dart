part of 'campsite_bloc.dart';

abstract class CampsiteEvent extends Equatable {
  const CampsiteEvent();

  @override
  List<Object> get props => [];
}
class SingleCampsiteRequested extends CampsiteEvent {
  final String campsiteId;
  const SingleCampsiteRequested({required this.campsiteId});

  @override
  List<Object> get props => [campsiteId];
}
