import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong/latlong.dart';
import 'package:map_elevation/map_elevation.dart';
import 'package:navigation_app/resources/models/named_point.dart';
import 'package:navigation_app/resources/models/route_step.dart';

class SavedRoute {
  String id;

  NamedPoint start;
  NamedPoint goal;

  List<RouteStep> routeSteps = [];
  List<double> messageBoundingBox = [];
  List<ElevationPoint> latLngRoutePoints = [];

  double ascent;
  double descent;

  List<LatLng> waypoints;
  List<Map<String, LatLng>> history;
  String routeGeoJsonString;

  Map _parsedRoute;

  SavedRoute({
    this.id,
    @required this.start,
    @required this.goal,
    @required this.waypoints,
    @required this.history,
    @required this.routeGeoJsonString,
  }) {
    _parsedRoute = json.decode(routeGeoJsonString) as Map;
    ascent = _parsedRoute['features'].first['properties']['ascent'] as double;
    descent = _parsedRoute['features'].first['properties']['descent'] as double;
    parseBoundingBox();
    parseRoutePoints();
    parseRouteSegments();
  }

  void parseBoundingBox() {
    try {
      messageBoundingBox
          .add(_parsedRoute['features'].first['bbox'][0] as double);
      messageBoundingBox
          .add(_parsedRoute['features'].first['bbox'][1] as double);
      messageBoundingBox
          .add(_parsedRoute['features'].first['bbox'][3] as double);
      messageBoundingBox
          .add(_parsedRoute['features'].first['bbox'][4] as double);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void parseRoutePoints() {
    try {
      latLngRoutePoints.addAll(_parsedRoute['features']
          .first['geometry']['coordinates']
          .map<ElevationPoint>((point) => ElevationPoint(
              point[1] as double, point[0] as double, point[2] as double))
          .toList() as List<ElevationPoint>);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void parseRouteSegments() {
    final segments = _parsedRoute['features'].first['properties']['segments'];

    for (final segment in segments) {
      for (final step in segment['steps']) {
        routeSteps.add(RouteStep(
          step['instruction'] as String,
          step['type'] as int,
          step['distance'].toInt() as int,
        ));
      }
    }
  }

  SavedRoute.fromMap(Map<String, dynamic> route, this.id) {
    start = NamedPoint.fromMap(point: route['start'] as Map<String, dynamic>);
    goal = NamedPoint.fromMap(point: route['goal'] as Map<String, dynamic>);
    ascent = route['ascent'] as double;
    descent = route['descent'] as double;
    messageBoundingBox = List<double>.from(route['boundingBox'] as List);
    routeGeoJsonString = route['geojson'] as String;
    history = <Map<String, LatLng>>[
      ...route['history']
          .map((e) => e
              .map(
                (String key, value) => MapEntry(
                    key,
                    LatLng(
                        value.latitude as double, value.longitude as double)),
              )
              .cast<String, LatLng>())
          .toList()
    ];
    latLngRoutePoints = <ElevationPoint>[
      ...route['line']
          .map((elevationPoint) => ElevationPoint(
                elevationPoint['latitude'] as double,
                elevationPoint['longitude'] as double,
                elevationPoint['altitude'] as double,
              ))
          .toList()
    ];
    routeSteps = <RouteStep>[
      ...route['routeSteps'].map((e) => RouteStep.fromMap(e as Map)).toList()
    ];
    waypoints = <LatLng>[
      ...route['waypoints']
          .map((point) =>
              LatLng(point.latitude as double, point.longitude as double))
          .toList()
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'start': start.toMap(),
      'goal': goal.toMap(),
      'routeSteps': routeSteps.map((e) => e.toMap()).toList(),
      'boundingBox': messageBoundingBox,
      'line': latLngRoutePoints
          .map<Map<String, double>>((elevationPoint) => {
                'latitude': elevationPoint.latitude,
                'longitude': elevationPoint.longitude,
                'altitude': elevationPoint.altitude,
              })
          .toList(),
      'waypoints': waypoints
          .map<GeoPoint>(
              (latLng) => GeoPoint(latLng.latitude, latLng.longitude))
          .toList(),
      'history': history
          .map((e) => e.map(
                (key, value) =>
                    MapEntry(key, GeoPoint(value.latitude, value.longitude)),
              ))
          .toList(),
      'geojson': routeGeoJsonString,
      'ascent': ascent,
      'descent': descent,
    };
  }

  @override
  String toString() {
    return 'SavedRoute{id: $id}';
  }
}
