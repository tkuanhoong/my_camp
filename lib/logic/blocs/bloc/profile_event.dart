part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileUpdateRequested extends ProfileEvent{
  final String userId;
  final String name;
  final String imagePath;
  const ProfileUpdateRequested({required this.userId,required this.name, required this.imagePath});

    @override
  List<Object> get props => [userId, name, imagePath];
}
