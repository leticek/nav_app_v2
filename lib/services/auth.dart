import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:navigation_app/resources/models/user_model.dart';

enum Status {Uninitialized, Authenticated, Authenticating, Unauthenticated}

class AuthService with ChangeNotifier{
  FirebaseAuth _firebaseAuth;
  GoogleSignIn _googleSignIn;
  User _user;
  UserModel _userModel;
  Status _status = Status.Uninitialized;
  String _error;

  Status get status => _status;

  AuthService.instance(){
    _firebaseAuth = FirebaseAuth.instance;
    _googleSignIn = GoogleSignIn(scopes: ['email']);
    _error = '';
    _firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      _error = '';
      return true;
    } catch (e) {
      _error = e.message; //TODO: handle error messages
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      _error = '';
      return true;
    } catch (e) {
      _error = e.message; //TODO: handle error messages
      _status = Status.Unauthenticated;
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
      _error = '';
      return true;
    } catch (e) {
      _error = e.message; //TODO: handle error messages
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
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(User firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
      _user = null;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }



}