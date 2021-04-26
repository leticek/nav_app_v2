import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../resources/enums.dart';
import '../resources/models/saved_route.dart';
import '../resources/models/user_model.dart';
import '../resources/providers.dart';
import '../resources/utils/validator.dart';

class AuthService with ChangeNotifier {
  FirebaseAuth _firebaseAuth;
  GoogleSignIn _googleSignIn;
  User _user;
  UserModel _userModel;
  AuthStatus _status = AuthStatus.uninitialized;
  String _errorCode;
  final Reader read;
  StreamSubscription _userListener;
  StreamSubscription _userRoutesListener;

  AuthStatus get status => _status;

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
      _status = AuthStatus.authenticating;
      notifyListeners();
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      _errorCode = '';
      return true;
    } catch (e) {
      _errorCode = Validator.checkError(e.code as String);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();
      final userCred = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      read(firestoreProvider).createUser(userCred.user);
      _errorCode = '';
      return true;
    } catch (e) {
      _errorCode = Validator.checkError(e.code as String);
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCred = await _firebaseAuth.signInWithCredential(credential);
      read(firestoreProvider).createUser(userCred.user);
      _errorCode = '';
      return true;
    } catch (e) {
      _errorCode = Validator.checkError(e.code as String);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    _firebaseAuth.signOut();
    _googleSignIn.signOut();
    _status = AuthStatus.unauthenticated;
    _userModel = null;
    _userListener.cancel();
    _userRoutesListener.cancel();
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  void deleteUser() {
    try {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      _userListener.cancel();
      _userRoutesListener.cancel();
      read(firestoreProvider).deleteUser(_firebaseAuth.currentUser.uid);
      _firebaseAuth.currentUser.delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _onAuthStateChanged(User firebaseUser) async {
    if (firebaseUser == null) {
      _status = AuthStatus.unauthenticated;
      _user = null;
    } else {
      _user = firebaseUser;
      _userListener =
          read(firestoreProvider).streamUserById(_user).listen((event) {
        if (_userModel != null) {
          final List<SavedRoute> tmp = _userModel.savedRoutes;
          _userModel = event;
          _userModel?.savedRoutes = tmp;
        } else {
          _userModel = event;
        }
        notifyListeners();
      });
      _userRoutesListener =
          read(firestoreProvider).streamUserRoutes(_user).listen((event) {
        _userModel?.savedRoutes = event;
        notifyListeners();
      });
      _status = AuthStatus.authenticated;
    }
    notifyListeners();
  }
}
