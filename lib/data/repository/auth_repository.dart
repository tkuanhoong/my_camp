import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:my_camp/data/models/user.dart';

class AuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //   Stream<FirebaseUser?> get authStateChanges {
  //   return _firebaseAuth.authStateChanges().map(_firebaseUser);
  // }

  //  FirebaseUser? _firebaseUser(User? user) {
  //   if(user == null){
  //     return null;
  //   }
  //   return FirebaseUser(id: user.uid);
  // }

  Future<void> signUp(
      {required String email,
      required String name,
      required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.updateDisplayName(name);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email.');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      }
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> verifyEmailVerification() async {
    Completer completer = Completer();
    try {
      Timer.periodic(const Duration(seconds: 3), (timer) async{
        User? user = _firebaseAuth.currentUser;
        if (user != null) {
          user.reload();
          if (timer.tick == 20) {
            completer.completeError('Email Verification Timed Out. Please Try Again.');
            await deleteUser();
            timer.cancel();
          }
          if (user.emailVerified) {
            completer.complete();
            timer.cancel();
          }
        }
      });
      await completer.future;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> sendEmailVerificationLink({required User user}) async {
    try {
      await user.sendEmailVerification();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> sendPasswordResetEmail(email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('User not found for that email.');
      } else {
        throw Exception(e.toString());
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> storeUserInfo() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      _db.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': user.displayName,
        'email': user.email,
        'created_at': DateTime.now(),
      });
    }
  }

  Future<void> deleteUser() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.delete();
    } else{
      throw Exception('User not found');
    }
  }
}
