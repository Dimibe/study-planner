import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import 'cache.service.dart';

final logger = Logger(printer: PrettyPrinter(methodCount: 0, printTime: true));

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserService() {
    addAuthStateListener((user) => GetIt.I<Cache>().reset());
  }

  StreamSubscription<User?> addAuthStateListener(
      void Function(User?) listener) {
    return _auth.authStateChanges().listen(listener);
  }

  Future<String> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _auth.currentUser!.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        logger.i('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        logger.i('Wrong password provided for that user.');
      }
    }
    throw 'Failed to login';
  }

  Future<String> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return _auth.currentUser!.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        logger.i('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        logger.i('The account already exists for that email.');
      }
    } catch (e) {
      logger.e(e);
    }
    throw 'Failed to register';
  }

  bool get isLoggedIn {
    return _auth.currentUser != null;
  }

  String? get email {
    return _auth.currentUser?.email;
  }

  String? getUid() {
    return _auth.currentUser?.uid;
  }

  Future<void> logout() async {
    GetIt.I<Cache>().reset();
    return FirebaseAuth.instance.signOut();
  }
}
