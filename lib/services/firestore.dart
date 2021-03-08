import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigation_app/resources/models/new_route.dart';
import 'package:navigation_app/resources/models/saved_route.dart';
import 'package:navigation_app/resources/models/user_model.dart';
import 'package:navigation_app/resources/providers.dart';

class FirestoreService {
  FirebaseFirestore _instance;
  ProviderContainer _providerContainer;

  FirestoreService.instance() {
    _providerContainer = ProviderContainer();
    _instance = FirebaseFirestore.instance;
    _instance.settings = Settings(persistenceEnabled: true);
    _instance.settings =
        Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  }

  Future<bool> createUser(UserModel userModel) async {
    try {
      DocumentSnapshot _doc =
          await _instance.collection('users').doc(userModel.userId).get();
      if (!_doc.exists)
        _instance
            .collection('users')
            .doc(userModel.userId)
            .set(userModel.toMap());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<UserModel> loadUser(String userId) async {
    try {
      DocumentSnapshot _doc = await _instance
          .collection('users')
          .doc(userId)
          .get(GetOptions(source: Source.serverAndCache));
      if (_doc.exists) {
        UserModel user = UserModel.fromFirestore(_doc.data());
        _instance
            .collection('users')
            .doc(userId)
            .collection('routes')
            .snapshots()
            .listen(user.addRouteFromStream);
        return user;
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> saveNewRoute(SavedRoute route) async {
    try {
      final userId =
          _providerContainer.read(authServiceProvider).userModel.userId;
      CollectionReference _collection =
          _instance.collection('users').doc(userId).collection('routes');
      _collection.add(route.toMap());
      return null;
    } catch (e) {
      print(e);
      return null;
    }
    return false;
  }
}
