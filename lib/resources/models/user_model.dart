import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:navigation_app/resources/models/saved_route.dart';

class UserModel {
  String userId;
  String email;
  List<SavedRoute> savedRoutes;

  UserModel.fromUser(User user) {
    userId = user.uid;
    email = user.email;
  }

  UserModel.fromFirestore(Map<String, dynamic> map) {
    debugPrint(map.toString());
    userId = map['userId'] as String;
    email = map['email'] as String;
  }

  Map<String, dynamic> toMap() {
    return {'userId': userId, 'email': email, 'firstLogin': DateTime.now()};
  }

  @override
  String toString() {
    return 'UserModel{userId: $userId, email: $email, savedRoutes: $savedRoutes}';
  }

}
