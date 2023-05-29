part of 'campsite_bloc.dart';

abstract class CampsiteEvent extends Equatable {
  const CampsiteEvent();

  @override
  List<Object> get props => [];
}

class SingleCampsiteRequested extends CampsiteEvent {
  final String campsiteId;
  final String? userId;
  const SingleCampsiteRequested(
      {required this.campsiteId, required this.userId});

  @override
  List<Object> get props => [campsiteId];
}
