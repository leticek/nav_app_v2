import 'package:flutter/material.dart';
import 'package:geojson/geojson.dart';
import 'package:latlong/latlong.dart';
import 'package:navigation_app/resources/models/named_point.dart';

import './route.dart';

class NewRoute extends AbstractRoute with ChangeNotifier {
  NewRoute() {
    waypoints = [];
    geoJson = GeoJson();
  }

  NamedPoint start;
  NamedPoint goal;
  List<LatLng> waypoints;
  GeoJson geoJson;

  List getRoute() {
    var list = [];
    list.add([start.point.longitude, start.point.latitude]);
    list.addAll(
        waypoints.map((point) => [point.longitude, point.latitude]).toList());
    list.add([goal.point.longitude, goal.point.latitude]);
    return list;
  }

  void clearRoute() {
    start = null;
    goal = null;
    waypoints = [];
    geoJson = null;
  }

  Future parseGeoJson(String geoJson) async {
    this.geoJson = GeoJson();
    await this.geoJson.parse(geoJson);
  }

  @override
  String toString() {
    return 'Start: ${start.toString()}  Goal: ${goal.toString()} ';
  }
}
