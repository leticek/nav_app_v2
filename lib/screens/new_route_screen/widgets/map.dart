import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:map_controller/map_controller.dart';

class MyMap extends StatelessWidget {
  const MyMap(
      {StatefulMapController controller,
      void Function(LatLng) onTap,
      void Function() onLongPress})
      : _controller = controller,
        _onTap = onTap,
        _onLongPress = onLongPress;

  final StatefulMapController _controller;
  final Function _onTap;
  final Function _onLongPress;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _controller.mapController,
      options: MapOptions(
        onTap: (latLng) => _onTap(latLng),
        onLongPress: (latLng) => _onLongPress(),
        zoom: 5,
        center: LatLng(49.761752, 15.427551),
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayerOptions(markers: _controller.markers),
        PolylineLayerOptions(polylines: _controller.lines)
      ],
    );
  }
}
