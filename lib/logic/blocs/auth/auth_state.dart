part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// This is the initial state of the bloc. When the user is not authenticated the state is changed to Unauthenticated.
class UnAuthenticated extends AuthState {}

// When the user presses the signin or signup button the state is changed to loading first and then to Authenticated.
class Loading extends AuthState {}

// When the user is verifying email.
class VerifyingEmail extends AuthState {
  final String email;

  const VerifyingEmail(this.email);
  @override
  List<Object> get props => [email];
}

// When the user is verified email.
class EmailVerified extends AuthState {}

// When the user is authenticated the state is changed to Authenticated.
class Authenticated extends AuthState {}

// If any error occurs the state is changed to AuthError.
class AuthError extends AuthState {
  final String error;

  const AuthError(this.error);
  @override
  List<Object> get props => [error];
}

class ForgotPasswordSent extends AuthState {
}
class ForgotPasswordTicking extends AuthState {
  final int timeOutSeconds;
  const ForgotPasswordTicking(this.timeOutSeconds);

  ForgotPasswordTicking copyWith({
    int? timeOutSeconds,
  }) {
    return ForgotPasswordTicking(
      timeOutSeconds ?? this.timeOutSeconds,
    );
  }

  @override
  List<Object?> get props => [timeOutSeconds];
}
class ForgotPasswordTimeOut extends AuthState {}

class ForgotPasswordSucess extends AuthState {}
