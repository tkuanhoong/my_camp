import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_camp/data/repository/phone_auth_repository.dart';

part 'phone_auth_event.dart';
part 'phone_auth_state.dart';

class PhoneAuthBloc extends Bloc<PhoneAuthEvent, PhoneAuthState> {
  final PhoneAuthRepository phoneAuthRepository;
  FirebaseAuth auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  PhoneAuthBloc({required this.phoneAuthRepository})
      : super(PhoneAuthInitial()) {
    // When user clicks on send otp button then this event will be fired
    on<PhoneAuthOtpRequested>(_sendOtpToUser);

    // After receiving the otp, When user clicks on verify otp button then this event will be fired
    on<PhoneAuthOtpPendingVerified>(_verifyOtpFromUser);

    // When the firebase sends the code to the user's phone, this event will be fired
    on<PhoneAuthOtpSent>((event, emit) =>
        emit(PhoneAuthCodeSentSuccess(verificationId: event.verificationId)));

    // When any error occurs while sending otp to the user's phone, this event will be fired
    on<PhoneAuthFailed>(
        (event, emit) => emit(PhoneAuthVerifyFailure(error: event.error)));

    // When the otp verification is successful, this event will be fired
    on<PhoneAuthVerified>(_loginWithCredential);
  }

  // Logics to handle the events

  // Send otp to the user's phone
  FutureOr<void> _sendOtpToUser(
      PhoneAuthOtpRequested event, Emitter<PhoneAuthState> emit) async {
    // Emit Loading state
    emit(PhoneAuthLoadInProgess());
    try {
      // call firebase auth to send otp to the user's phone
      await phoneAuthRepository.verifyPhone(
        phoneNumber: event.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          // On [verificationCompleted], we will get the credential from the firebase
          // the credential will send to the [PhoneAuthVerified] event to be handled by the bloc
          // and then bloc will emit the [PhoneAuthVerified] state
          // after successful login
          add(PhoneAuthVerified(credential: credential));
        },
        verificationFailed: (FirebaseAuthException e) {
          add(PhoneAuthFailed(error: e.toString()));
        },
        codeSent: (String verificationId, int? token) {
          add(PhoneAuthOtpSent(verificationId: verificationId, token: token));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      emit(PhoneAuthVerifyFailure(error: e.toString()));
    }
  }

  FutureOr<void> _verifyOtpFromUser(
      PhoneAuthOtpPendingVerified event, Emitter<PhoneAuthState> emit) async {
    try {
      emit(PhoneAuthLoadInProgess());
      // After receiving the otp, we will verify the otp and create a credential from the otp
      // and verificationId and then will send it to the [PhoneAuthVerified] event to be handled by the bloc
      // and then will emit the [PhoneAuthVerified] state after successful login
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: event.verificationId, smsCode: event.otpCodeReceived);
      add(PhoneAuthVerified(credential: credential));
    } catch (e) {
      emit(PhoneAuthVerifyFailure(error: e.toString()));
    }
  }

  FutureOr<void> _loginWithCredential(
      PhoneAuthVerified event, Emitter<PhoneAuthState> emit) async {
    // After receiving the credential from the event, we will login with the credential
    // and then will emit the [PhoneAuthVerifySuccess] state after successful login
    try {
            // emit(PhoneAuthLoadInProgess());
      await auth.signInWithCredential(event.credential).then((userData) async{
        if (userData.user != null) {
          await db.collection('users').doc(userData.user!.uid).get().then((user) async {
            if(user.exists){
              await db.collection('users').doc(userData.user!.uid).update({
                'lastTimeLoggedIn': DateTime.now(),
              });
            }else {
              await db.collection('users').doc(userData.user!.uid).set({
              'id': userData.user!.uid,
              'name': 'Test User',
              'phone': userData.user!.phoneNumber,
              'createdAt': DateTime.now(),
              'lastTimeLoggedIn': DateTime.now(),
            });
            }
          });
          
          emit(PhoneAuthVerifySuccess());
        }
      });
    } on FirebaseAuthException catch (e) {
      emit(PhoneAuthVerifyFailure(error: e.code));
    } catch (e) {
      emit(PhoneAuthVerifyFailure(error: e.toString()));
    }
  }
}
