// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'phone_auth_bloc.dart';

abstract class PhoneAuthState extends Equatable {
  const PhoneAuthState();

  @override
  List<Object> get props => [];
}

// Initial state:
class PhoneAuthInitial extends PhoneAuthState {}

//  loading
class PhoneAuthLoadInProgess extends PhoneAuthState {}

// App sent OTP to user's phone number
class PhoneAuthCodeSentSuccess extends PhoneAuthState {
  final String verificationId;
  const PhoneAuthCodeSentSuccess({
    required this.verificationId,
  });
  @override
  List<Object> get props => [verificationId];

  @override
  String toString() => 'PhoneAuthCodeSentSuccess(verificationId: $verificationId)';
}

// Verification is completed and user is logged in
class PhoneAuthVerifySuccess extends PhoneAuthState {}

// Verification is not completed and error is thrown
class PhoneAuthVerifyFailure extends PhoneAuthState {
  final String error;

  const PhoneAuthVerifyFailure({required this.error});

  @override
  List<Object> get props => [error];
  

  @override
  String toString() => 'PhoneAuthVerifyFailure(error: $error)';
}
