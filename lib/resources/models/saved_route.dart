import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong/latlong.dart';
import 'package:navigation_app/resources/models/named_point.dart';
import 'package:navigation_app/resources/models/route_segment.dart';

class SavedRoute {
  NamedPoint start;
  NamedPoint goal;

  List<RouteSegment> routeSegments;
  List<double> messageBoundingBox = [];
  List<LatLng> latLngRoutePoints = [];

  List<LatLng> waypoints;
  List<Map<String, LatLng>> history;
  String routeGeoJsonString;

  Map _parsedRoute;

  SavedRoute({
    @required this.start,
    @required this.goal,
    @required this.waypoints,
    @required this.history,
    @required this.routeGeoJsonString,
  }) {
    _parsedRoute = json.decode(routeGeoJsonString);
    parseBoundingBox();
    parseRoutePoints();
  }

  void parseBoundingBox() {
    try {
      messageBoundingBox.add(_parsedRoute['features'].first['bbox'][0]);
      messageBoundingBox.add(_parsedRoute['features'].first['bbox'][1]);
      messageBoundingBox.add(_parsedRoute['features'].first['bbox'][3]);
      messageBoundingBox.add(_parsedRoute['features'].first['bbox'][4]);
    } catch (e) {
      print(e);
    }
  }

  void parseRoutePoints() {
    try {
      latLngRoutePoints.addAll(_parsedRoute['features']
          .first['geometry']['coordinates']
          .map<LatLng>((point) => LatLng(point[1], point[0]))
          .toList());
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toMap() {
    return null;
  }
}
