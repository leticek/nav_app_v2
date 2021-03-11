import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:navigation_app/resources/models/saved_route.dart';
import 'package:navigation_app/resources/models/user_model.dart';

class FirestoreService {
  FirebaseFirestore _instance;

  FirestoreService.instance() {
    _instance = FirebaseFirestore.instance;
    _instance.settings = const Settings(persistenceEnabled: true);
    _instance.settings =
        const Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  }

  Future<bool> saveNewRoute(SavedRoute route, String id) async {
    try {
      final _collection =
          _instance.collection('users').doc(id).collection('routes');
      _collection.doc(route.id).set(route.toMap());
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  UserModel createUser(User user) {
    try {
      final userModel = UserModel.fromUser(user);
      _instance.collection('users').doc(user.uid).set(userModel.toMap());
      return userModel;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Stream<UserModel> streamUserById(User user) {
    return _instance.collection('users').doc(user.uid).snapshots().map((snap) =>
        snap.exists ? UserModel.fromFirestore(snap.data()) : null);
  }
}
