import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_camp/data/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc({required this.authRepository}) : super(UnAuthenticated()) {
    // When User Presses the SignIn Button, we will send the SignInRequested Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated
    on<SignInRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.signIn(
            email: event.email, password: event.password);
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null && !user.emailVerified) {
          await authRepository.sendEmailVerificationLink(user: user);
          add(EmailVerificationSent(email: user.email!));
        }
        emit(Authenticated());
      } catch (e) {
        // emit(AuthError(e.toString()));
        emit(const AuthError('Invalid Email or Password'));
        emit(UnAuthenticated());
      }
    });
    // When User Presses the SignUp Button, we will send the SignUpRequest Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated
    on<SignUpRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.signUp(
            email: event.email, name: event.userName, password: event.password);
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null && !user.emailVerified) {
          await authRepository.sendEmailVerificationLink(user: user);
          add(EmailVerificationSent(email: user.email!));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });
    // When user's verification email sent, we will send the EmailVerificationSent Event to the AuthBloc to handle it and emit the UnAuthenticated State
    on<EmailVerificationSent>((event, emit) async {
      emit(VerifyingEmail(event.email));
      try {
        await authRepository.verifyEmailVerification();
        await authRepository.storeUserInfo();
        emit(Authenticated());
      } catch (e) {
        await authRepository.deleteUser();
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });
    on<ResendVerificationEmail>((event, emit) async {
      emit(Loading());
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null && !user.emailVerified) {
          await authRepository.sendEmailVerificationLink(user: user);
          add(EmailVerificationSent(email: user.email!));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });
    // When User Presses the SignOut Button, we will send the SignOutRequested Event to the AuthBloc to handle it and emit the UnAuthenticated State
    on<SignOutRequested>((event, emit) async {
      emit(Loading());
      await authRepository.signOut();
      emit(UnAuthenticated());
    });

    on<ForgotPasswordRequested>((event, emit) async {
      int timeOutSeconds = 60;
      emit(Loading());
      try {
        await authRepository.sendPasswordResetEmail(event.email);
        Timer.periodic(const Duration(seconds: 1), (timer) {
          timeOutSeconds--;
          add(ForgotPasswordTicked(timeOutSeconds));
          if (timeOutSeconds == 0) {
            timer.cancel();
          }
        });
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    on<ForgotPasswordTicked>((event, emit) async {
      try {
        if (event.timeOutSeconds > 0) {
          emit(ForgotPasswordTicking(event.timeOutSeconds));
        } else {
          emit(ForgotPasswordTimeOut());
        }
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });
  }
}
