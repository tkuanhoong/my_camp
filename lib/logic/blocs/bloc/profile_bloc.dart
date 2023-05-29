import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_camp/data/models/user_model.dart';
import 'package:my_camp/data/repository/user_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  UserRepository userRepository;
  ProfileBloc({required this.userRepository}) : super(ProfileInitial()) {
    on<ProfileUpdateRequested>((event, emit) async {
      emit(ProfileUpdateLoading());
      try {
        await userRepository.updateUser(event.userId, event.name);
        emit(ProfileUpdatedSuccess(
            user: await userRepository.fetchUser(event.userId)));
      } catch (e) {
        emit(ProfileUpdatedFailure(error: e.toString()));
      }
    });
  }
}