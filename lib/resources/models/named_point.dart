import 'package:latlong/latlong.dart';

class NamedPoint {
  String name;
  LatLng point;

  NamedPoint(this.name, this.point);

  @override
  String toString() {
    return point.toString();
  }

  NamedPoint.fromPoint(LatLng point)
      : this.name = '${point.latitude} ${point.longitude}',
        this.point = point;
}
