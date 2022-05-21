import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import './cache.dart';

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
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
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
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
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
