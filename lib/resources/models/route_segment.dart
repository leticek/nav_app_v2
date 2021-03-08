import 'package:latlong/latlong.dart';

class RouteSegment {
  bool passed;
  final String instruction;
  final int type;
  final LatLng startPoint;
  final LatLng endPoint;
  final int startWayPoint;
  final int finishWayPoint;
  final int distance;

  RouteSegment(this.passed, this.instruction, this.type, this.startPoint,
      this.endPoint, this.startWayPoint, this.finishWayPoint, this.distance);

  Map toMap() => {
        "passed": passed,
        "instruction": instruction,
        "type": type,
        "startPoint": {
          "latitude": startPoint.latitude,
          "longitude": startPoint.longitude,
        },
        "endPoint": {
          "latitude": endPoint.latitude,
          "longitude": endPoint.longitude,
        },
        "startWayPoint": startWayPoint,
        "finishWayPoint": finishWayPoint,
        "distance": distance
      };

  @override
  String toString() {
    return 'RouteSegment{passed: $passed, instruction: $instruction, type: $type, startPoint: $startPoint, endPoint: $endPoint, startWayPoint: $startWayPoint, finishWayPoint: $finishWayPoint, distance: $distance}';
  }
}
