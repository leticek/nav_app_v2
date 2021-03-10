import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong/latlong.dart';

class NamedPoint {
  String name;
  LatLng point;

  NamedPoint(this.name, this.point);
  NamedPoint.fromMap({Map<String, GeoPoint> point}){
    name = point['name'] as String;
    point = LatLng(point['point'].latitude, point['point'].longitude) as Map<String, GeoPoint>;
  }


  @override
  String toString() {
    return point.toString();
  }

  NamedPoint.fromPoint(LatLng point)
      : this.name = '${point.latitude} ${point.longitude}',
        this.point = point;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'point': GeoPoint(point.latitude, point.longitude),
    };
  }
}
