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

  Future<bool> saveNewRoute(SavedRoute route, String id) async {
    try {
      final _collection =
          _instance.collection('users').doc(id).collection('routes');
      await _collection.add(route.toMap());
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
        (snap) => snap.exists ? UserModel.fromFirestore(snap.data()) : null);
  }

  Stream<List<SavedRoute>> streamUserRoutes(User user) {
    final List<DocumentSnapshot> changedDocs = [];
    return _instance
        .collection('users/${user.uid}/routes')
        .snapshots()
        .map((snap) {
      print(DateTime.now().toIso8601String());
      print('cache: ${snap.metadata.isFromCache}');
      print('počet cest: ${snap.docs.length}');
      print('počet zmeň: ${snap.docChanges.length}');
      print('změna: ${snap.docChanges.first.type}');
      for (final docs in snap.docChanges) {
        if (docs.type == DocumentChangeType.added ||
            docs.type == DocumentChangeType.modified) {
          changedDocs.add(docs.doc);
        }
      }
      return snap.docChanges.isNotEmpty ? loadRoutes(changedDocs) : null;
    });
  }

  List<SavedRoute> loadRoutes(List<DocumentSnapshot> docs) {
    final List<SavedRoute> list = [];
    for (final documentSnap in docs) {
      list.add(SavedRoute.fromMap(documentSnap.data()));
    }
    return list;
  }
}
