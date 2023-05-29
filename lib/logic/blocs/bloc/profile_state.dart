part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  
  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileUpdateLoading extends ProfileState {}

class ProfileUpdatedSuccess extends ProfileState {
  final UserModel user;

  const ProfileUpdatedSuccess({required this.user});

  @override
  List<Object> get props => [user];
}
class ProfileUpdatedFailure extends ProfileState{
  final String error;
  const ProfileUpdatedFailure({required this.error});
  @override
  List<Object> get props => [error];
}
