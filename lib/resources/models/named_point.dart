import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong/latlong.dart';

class NamedPoint {
  String name;
  LatLng point;

  NamedPoint(this.name, this.point);

  NamedPoint.fromMap({Map<String, dynamic> point}) {
    name = point['name'] as String;
    this.point = LatLng(
        point['point'].latitude as double, point['point'].longitude as double);
  }

  @override
  String toString() {
    return point.toString();
  }

  NamedPoint.fromPoint(this.point)
      : name = '${point.latitude} ${point.longitude}';

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'point': GeoPoint(point.latitude, point.longitude),
    };
  }
}
