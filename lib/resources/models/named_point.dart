import 'package:latlong/latlong.dart';

class NamedPoint {
  String name;
  LatLng point;

  @override
  String toString() {
    return 'NamedPoint{name: $name, LatLng: ${point.toString()}}';
  }

  NamedPoint.fromPlaceSuggestion(this.name, this.point);
}
