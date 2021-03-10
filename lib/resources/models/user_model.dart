import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:navigation_app/resources/models/saved_route.dart';

class UserModel {
  String userId;
  String email;
  List<SavedRoute> savedRoutes;

  UserModel.fromUser(User user) {
    userId = user.uid;
    email = user.email;
  }

  UserModel.fromFirestore(Map<String, dynamic> _map) {
    userId = _map['userId'];
    email = _map['email'];
  }

  Map<String, dynamic> toMap() {
    return {'userId': userId, 'email': email, 'firstLogin': DateTime.now()};
  }

  @override
  String toString() {
    return 'UserModel{userId: $userId, email: $email, savedRoutes: $savedRoutes}';
  }

}
