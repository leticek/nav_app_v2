import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:navigation_app/resources/models/saved_route.dart';
import 'package:navigation_app/resources/models/user_model.dart';

class FirestoreService {
  FirebaseFirestore _instance;

  FirestoreService.instance() {
    _instance = FirebaseFirestore.instance;
    _instance.settings = Settings(persistenceEnabled: true);
    _instance.settings =
        Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  }

  Future<bool> saveNewRoute(SavedRoute route, String id) async {
    try {
      CollectionReference _collection =
          _instance.collection('users').doc(id).collection('routes');
      _collection.doc(route.id).set(route.toMap());
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  UserModel createUser(User user) {
    try {
      UserModel userModel = UserModel.fromUser(user);
      _instance.collection('users').doc(user.uid).set(userModel.toMap());
      return userModel;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<UserModel> streamUserById(User user) {
    return _instance.collection('users').doc(user.uid).snapshots().map((snap) =>
        snap.exists ? UserModel.fromFirestore(snap.data()) : null);
  }
}
