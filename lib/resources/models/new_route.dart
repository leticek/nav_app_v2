import 'package:geojson/geojson.dart';
import 'package:latlong/latlong.dart';
import 'package:navigation_app/resources/models/named_point.dart';

class NewRoute {
  NewRoute() : geoJson = GeoJson();

  NamedPoint start;
  NamedPoint goal;
  List<LatLng> waypoints = [];
  GeoJson geoJson;

  List getWaypoints() {
    var list = [];
    list.add([start.point.longitude, start.point.latitude]);
    list.addAll(
        waypoints.map((point) => [point.longitude, point.latitude]).toList());
    list.add([goal.point.longitude, goal.point.latitude]);
    print(list);
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
