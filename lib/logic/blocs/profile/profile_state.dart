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

class ProfileUpdatedFailure extends ProfileState {
  final String error;
  const ProfileUpdatedFailure({required this.error});
  @override
  List<Object> get props => [error];
}

class PictureUploading extends ProfileState {}

class PictureChanged extends ProfileState {
  final File image;
  const PictureChanged({required this.image});
  @override
  List<Object> get props => [image];
}

class PictureChangedFailure extends ProfileState {
  final String error;
  const PictureChangedFailure({required this.error});
  @override
  List<Object> get props => [error];
}

class ProfileFetchedSuccess extends ProfileState {
  final File image;
  const ProfileFetchedSuccess({required this.image});
  @override
  List<Object> get props => [image];
}

class ProfileFetching extends ProfileState {}

class ProfileFetchError extends PictureChangedFailure {
  const ProfileFetchError({required super.error});
  @override
  List<Object> get props => [error];
}
