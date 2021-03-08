import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong/latlong.dart';
import 'package:navigation_app/resources/models/named_point.dart';
import 'package:navigation_app/resources/models/route_segment.dart';

class SavedRoute {
  NamedPoint start;
  NamedPoint goal;

  List<RouteSegment> routeSegments;
  List<LatLng> boundingBox;
  List<LatLng> waypoints;
  List<Map<String, LatLng>> history;
  String routeGeoJsonString;

  SavedRoute({
    @required this.start,
    @required this.goal,
    @required this.waypoints,
    @required this.history,
    @required this.routeGeoJsonString,
  }) {
    print('');
  }

  Map<String, dynamic> toMap() {
    return null;
  }
}
