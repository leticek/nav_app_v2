import 'package:latlong/latlong.dart';

class PlaceSuggestion {
  final String _label;
  final LatLng _latLng;

  String get label => _label;

  LatLng get latLng => _latLng;

  PlaceSuggestion(this._label, this._latLng);

  @override
  String toString() => 'Name: $_label Place: ${_latLng.toString()}';
}
