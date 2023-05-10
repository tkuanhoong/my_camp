part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// When the user signing in with email and password this event is called and the [AuthRepository] is called to sign in the user
class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested(this.email, this.password);
}

// When the user signing up with email and password this event is called and the [AuthRepository] is called to sign up the user
class SignUpRequested extends AuthEvent {
  final String email;
  final String userName;
  final String password;

  const SignUpRequested(this.email, this.userName,this.password);
}

class EmailVerificationSent extends AuthEvent {
  final String email;
  const EmailVerificationSent({required this.email});
}

class ResendVerificationEmail extends AuthEvent {
  final String email;
  const ResendVerificationEmail({required this.email});
}

// When the user signing out this event is called and the [AuthRepository] is called to sign out the user
class SignOutRequested extends AuthEvent {}

class ForgotPasswordRequested extends AuthEvent {
  final String email;
  const ForgotPasswordRequested({required this.email});
}

class ForgotPasswordTicked extends AuthEvent {
  final int timeOutSeconds;
  const ForgotPasswordTicked(this.timeOutSeconds);
}
