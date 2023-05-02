part of 'phone_auth_bloc.dart';

abstract class PhoneAuthEvent extends Equatable {
  const PhoneAuthEvent();

  @override
  List<Object> get props => [];
}

// When user requests to send OTP to user's phone number
class PhoneAuthOtpRequested extends PhoneAuthEvent {
  final String phoneNumber;

  const PhoneAuthOtpRequested({required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}

// When OTP is sent to user's phone number
class PhoneAuthOtpSent extends PhoneAuthEvent {
  // Receive verificationId, token response from firebase
  // verificationId is then used to log in to the user.
  final String verificationId;
  final int? token;
  const PhoneAuthOtpSent({required this.verificationId, required this.token});
  @override
  List<Object> get props => [verificationId];
}

// When user requests to verify OTP
class PhoneAuthOtpPendingVerified extends PhoneAuthEvent {
  final String otpCodeReceived;
  final String verificationId;
  const PhoneAuthOtpPendingVerified(
      {required this.otpCodeReceived, required this.verificationId});
  @override
  List<Object> get props => [otpCodeReceived, verificationId];
}

// When user failed to verify OTP
class PhoneAuthFailed extends PhoneAuthEvent {
  // error message
  final String error;
  const PhoneAuthFailed({required this.error});
  @override
  List<Object> get props => [error];
}

// When user successfully verify OTP
class PhoneAuthVerified extends PhoneAuthEvent {
  final AuthCredential credential;
  const PhoneAuthVerified({
    required this.credential,
  });
}
