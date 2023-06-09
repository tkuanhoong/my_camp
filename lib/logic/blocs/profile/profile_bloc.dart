import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_camp/data/models/user_model.dart';
import 'package:my_camp/data/repository/user_repository.dart';
import 'dart:io';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  UserRepository userRepository;
  ProfileBloc({required this.userRepository}) : super(ProfileInitial()) {
    on<ProfileFetchRequested>((event, emit) async {
      emit(ProfileFetching());
      try {
        UserModel user = await userRepository.fetchUser(event.userId);
        emit(ProfileFetchedSuccess(user: user));
      } catch (e) {
        emit(ProfileFetchError(error: e.toString()));
      }
    });
    on<ProfileUpdateRequested>((event, emit) async {
      emit(ProfileUpdateLoading());
      try {
        await userRepository.updateUser(event.userId, event.name, event.image);
        emit(ProfileUpdatedSuccess(
            user: await userRepository.fetchUser(event.userId)));
      } catch (e) {
        emit(ProfileUpdatedFailure(error: e.toString()));
      }
    });

    on<AddPictureButtonClicked>((event, emit) async {
      emit(PictureUploading());
      try {
        File? image = await userRepository.changeImage();
        emit(PictureChanged(image: image!));
      } catch (e) {
        emit(PictureChangedFailure(error: e.toString()));
      }
    });
  }
}
