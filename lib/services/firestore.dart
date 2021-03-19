import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navigation_app/resources/models/saved_route.dart';
import 'package:navigation_app/resources/models/user_model.dart';

class FirestoreService {
  FirebaseFirestore _instance;

  FirestoreService.instance() {
    _instance = FirebaseFirestore.instance;
    _instance.settings = const Settings(
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
        persistenceEnabled: true);
  }

  Future<bool> saveNewRoute(SavedRoute route, String userId) async {
    try {
      final _collection =
      _instance.collection('users').doc(userId).collection('routes');
      await _collection.add(route.toMap());
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> updateRoute(SavedRoute route, String userId) async {
    try {
      _instance.collection('users/$userId/routes').doc(route.id).set(
          route.toMap());
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
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
    return _instance.collection('users').doc(user.uid).snapshots().map(
            (snap) =>
        snap.exists
            ? UserModel.fromFirestore(snap.data())
            : null);
  }

  Stream<List<SavedRoute>> streamUserRoutes(User user) {
    final Map<String, DocumentSnapshot> changedDocs = {};
    return _instance
        .collection('users/${user.uid}/routes')
        .snapshots()
        .map((snap) {
      for (final docChange in snap.docChanges) {
        switch (docChange.type) {
          case DocumentChangeType.removed:
            changedDocs.remove(docChange.doc.id);
            break;
          case DocumentChangeType.added:
            changedDocs.putIfAbsent(docChange.doc.id, () => docChange.doc);
            break;
          case DocumentChangeType.modified:
            changedDocs.update(docChange.doc.id, (value) => docChange.doc);
            break;
        }
      }
      return changedDocs.isNotEmpty
          ? loadRoutes(changedDocs.values.toList())
          : [];
    });
  }

  List<SavedRoute> loadRoutes(List<DocumentSnapshot> docs) {
    final List<SavedRoute> list = [];
    for (final documentSnap in docs) {
      list.add(SavedRoute.fromMap(documentSnap.data(), documentSnap.id));
    }
    return list;
  }

  void deleteRoute(String userId, String routeId) {
    _instance.collection('users/$userId/routes').doc(routeId).delete();
  }
}
