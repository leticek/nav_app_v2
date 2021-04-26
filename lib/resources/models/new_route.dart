import 'package:geojson/geojson.dart';
import 'package:latlong/latlong.dart';

import './named_point.dart';
import 'saved_route.dart';

class NewRoute {
  NewRoute();

  NamedPoint start;
  NamedPoint goal;
  List<LatLng> waypoints = [];
  String geoJsonString;
  GeoJson geoJson;

  NewRoute.fromSavedRoute(SavedRoute savedRoute) {
    start = savedRoute.start;
    goal = savedRoute.goal;
    waypoints = List.from(savedRoute.waypoints);
    geoJsonString = savedRoute.routeGeoJsonString;
  }

  List getWaypoints() {
    final list = [];
    list.add([start.point.longitude, start.point.latitude]);
    list.addAll(
        waypoints.map((point) => [point.longitude, point.latitude]).toList());
    list.add([goal.point.longitude, goal.point.latitude]);
    return list;
  }

  Future parseGeoJson(String geoJson) async {
    await this.geoJson.parse(geoJson);
  }

  @override
  String toString() {
    return 'Start: ${start.toString()}  Goal: ${goal.toString()} ';
  }
}
