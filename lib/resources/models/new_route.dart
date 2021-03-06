import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

class NewRoute with ChangeNotifier {
  LatLng start;
  LatLng goal;
  List<LatLng> waypoints;

  @override
  String toString() {
    return 'Start: ${start.toString()}  Goal: ${goal.toString()}';
  }

  NewRoute();
}
