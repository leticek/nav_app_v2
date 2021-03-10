import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:navigation_app/resources/enums.dart';
import 'package:navigation_app/resources/models/user_model.dart';
import 'package:navigation_app/resources/providers.dart';
import 'package:navigation_app/services/validator.dart';

class AuthService with ChangeNotifier {
  FirebaseAuth _firebaseAuth;
  GoogleSignIn _googleSignIn;
  User _user;
  UserModel _userModel;
  Status _status = Status.Uninitialized;
  String _errorCode;
  final Reader read;
  StreamSubscription _userListener;

  Status get status => _status;

  String get errorCode => _errorCode;

  UserModel get userModel => _userModel;

  AuthService.instance(this.read) {
    _firebaseAuth = FirebaseAuth.instance;
    _googleSignIn = GoogleSignIn(scopes: ['email']);
    _errorCode = '';
    _firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      _errorCode = '';
      return true;
    } catch (e) {
      _errorCode = Validator.checkError(e.code);
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      _errorCode = '';
      return true;
    } catch (e) {
      _errorCode = Validator.checkError(e.code);
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
      _errorCode = '';
      return true;
    } catch (e) {
      _errorCode = Validator.checkError(e.code);
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    _firebaseAuth.signOut();
    _googleSignIn.signOut();
    _status = Status.Unauthenticated;
    _userModel = null;
    _userListener.cancel();
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(User firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
      _user = null;
    } else {
      _user = firebaseUser;
      _userListener =
          read(firestoreProvider).streamUserById(_user).listen((event) {
        _userModel = event;
      });
      _status = Status.Authenticated;
    }
    notifyListeners();
  }
}
