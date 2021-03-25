import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:navigation_app/resources/models/saved_route.dart';

class UserModel with ChangeNotifier {
  String userId;
  String email;
  List<SavedRoute> savedRoutes = [];
  int mapStyle;
  TileLayerOptions mapOptions;
  int routeProfileId;
  String routeProfile;

  UserModel.fromUser(User user) {
    userId = user.uid;
    email = user.email;
  }

  UserModel.fromFirestore(Map<String, dynamic> map) {
    userId = map['userId'] as String;
    email = map['email'] as String;
    mapStyle = map['mapStyle'] as int;
    routeProfileId = map['routeProfile'] as int;
    _setMapStyle(mapStyle);
    _setRouteProfile(routeProfileId);
  }

  void _setRouteProfile(int routeProfileId){
    switch(routeProfileId){
      case 0:
        routeProfile = 'cycling-regular';
        break;
      case 1:
        routeProfile = 'cycling-mountain';
        break;
      case 2:
        routeProfile = 'foot-walking';
        break;
      case 3:
        routeProfile = 'foot-hiking';
        break;
      default:
        routeProfile = 'foot-walking';
        break;
    }
  }

  void _setMapStyle(int styleId) {
    switch (mapStyle) {
      case 0:
        mapOptions = TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        );
        break;
      case 1:
        mapOptions = TileLayerOptions(
          urlTemplate: "https://tiles.wmflabs.org/hikebike/{z}/{x}/{y}.png",
        );
        break;
      case 2:
        mapOptions = TileLayerOptions(
          urlTemplate: "https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        );
        break;
      default:
        mapOptions = TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        );
        break;
    }
  }

  Map<String, dynamic> toMap() {
    return {'userId': userId, 'email': email, 'firstLogin': DateTime.now()};
  }

  @override
  String toString() {
    return 'UserModel{userId: $userId, email: $email, savedRoutes: $savedRoutes}';
  }

  bool removeRoute(SavedRoute route) {
    final result = savedRoutes.remove(route);
    notifyListeners();
    return result;
  }
}
