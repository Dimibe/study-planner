import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserService();

  addAuthStateListener(Function(User) listener) {
    return _auth.authStateChanges().listen(listener);
  }

  Future<String> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _auth.currentUser.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    return null;
  }

  get isLoggedIn {
    return _auth.currentUser != null;
  }

  String getUid() {
    return _auth.currentUser.uid;
  }
}
