import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_camp/data/models/user_model.dart';

part 'session_state.dart';

class SessionCubit extends HydratedCubit<SessionState> {
  SessionCubit() : super(const SessionState());

  void setFirstLaunched() => emit(state.copyWith(isFirstLaunched: true));

  void setUserSession() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      emit(state.copyWith(
          isAuthenticated: true,
          id: user.uid,
          userName: user.displayName,
          email: user.email));
    }
  }

  void clearUserSession()  =>  emit(const SessionState(isAuthenticated: false,isFirstLaunched: true));

  void updateUserSession(UserModel user) => emit(state.copyWith(userName: user.name, imagePath: user.imagePath));

  // Called everytime the app needs store data
  @override
  SessionState? fromJson(Map<String, dynamic> json) =>
      SessionState.fromMap(json);

  // Called for every state
  @override
  Map<String, dynamic>? toJson(SessionState state) => state.toMap();
}
