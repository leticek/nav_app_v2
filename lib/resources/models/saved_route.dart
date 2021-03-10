import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong/latlong.dart';
import 'package:navigation_app/resources/models/named_point.dart';
import 'package:navigation_app/resources/models/route_step.dart';

class SavedRoute {
  String id;

  NamedPoint start;
  NamedPoint goal;

  List<RouteStep> routeSteps = [];
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
    id = DateTime.now().toIso8601String();
    _parsedRoute = json.decode(routeGeoJsonString);
    parseBoundingBox();
    parseRoutePoints();
    parseRouteSegments();
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

  void parseRouteSegments() {
    List<dynamic> segments =
        _parsedRoute['features'].first['properties']['segments'];

    for (dynamic segment in segments) {
      for (dynamic step in segment['steps']) {
        routeSteps.add(RouteStep(
          step['instruction'],
          step['type'],
          step['distance'].toInt(),
        ));
      }
    }
  }

  SavedRoute.fromMap({Map route}){
    //TODO: dodělat rozparsovaní
    id = route['id'];
    start = NamedPoint.fromMap(point: route['start']);
    goal = NamedPoint.fromMap(point: route['goal']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'start': start.toMap(),
      'goal': goal.toMap(),
      'routeSteps': routeSteps.map((e) => e.toMap()).toList(),
      'boundingBox': messageBoundingBox,
      'line': latLngRoutePoints
          .map<GeoPoint>(
              (latLng) => GeoPoint(latLng.latitude, latLng.longitude))
          .toList(),
      'waypoints': waypoints
          .map<GeoPoint>(
              (latLng) => GeoPoint(latLng.latitude, latLng.longitude))
          .toList(),
      'history': history
          .map(
            (e) => e.map((key, value) =>
                MapEntry(key, GeoPoint(value.latitude, value.latitude))),
          )
          .toList(),
      'geojson': routeGeoJsonString,
    };
  }
}
