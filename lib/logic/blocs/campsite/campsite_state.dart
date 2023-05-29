part of 'campsite_bloc.dart';

abstract class CampsiteState extends Equatable {
  const CampsiteState();
  
  @override
  List<Object> get props => [];
}

class CampsiteInitial extends CampsiteState {}
class CampsiteLoading extends CampsiteState {}
class CampsiteLoaded extends CampsiteState {
  final Campsite campsite;
  const CampsiteLoaded({required this.campsite});
  @override
  List<Object> get props => [campsite];
}
class CampsiteError extends CampsiteState {
  final String error;
  const CampsiteError({required this.error});
  @override
  List<Object> get props => [error];
}
