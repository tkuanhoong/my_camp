part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileUpdateRequested extends ProfileEvent {
  final String userId;
  final String name;
  final File? image;
  const ProfileUpdateRequested(
      {required this.userId, required this.name, this.image});

  @override
  List<Object?> get props => [userId, name, image];
}

class ProfileFetchRequested extends ProfileEvent {
  final String userId;
  const ProfileFetchRequested({required this.userId});
}

class AddPictureButtonClicked extends ProfileEvent {}
