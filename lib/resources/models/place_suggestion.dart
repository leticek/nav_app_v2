import 'package:latlong/latlong.dart';
import 'package:navigation_app/resources/models/named_point.dart';

class PlaceSuggestion {
  final String label;
  final LatLng latLng;



  PlaceSuggestion({this.label, this.latLng});

  @override
  String toString() => 'Name: $label Place: ${latLng.toString()}';

  NamedPoint toNamedPoint({LatLng point}) => NamedPoint.fromPlaceSuggestion(
      this.label ?? '${point.latitude}  ${point.longitude}',
      this.latLng ?? point);
}
