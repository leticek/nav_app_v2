import 'package:latlong/latlong.dart';

class MyPoint {
  // ignore: type_annotate_public_apis, prefer_typing_uninitialized_variables
  var x;

  // ignore: type_annotate_public_apis, prefer_typing_uninitialized_variables
  var y;

  MyPoint.fromLatLng(LatLng latLng) {
    x = latLng.latitude;
    y = latLng.longitude;
  }

  LatLng fromPoint() => LatLng(x as double, y as double);
}
