import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:map_controller/map_controller.dart';
import 'package:navigation_app/resources/models/saved_route.dart';
import 'package:navigation_app/resources/widget_view.dart';

class RoutePreview extends StatefulWidget {
  @override
  _RoutePreviewController createState() => _RoutePreviewController();

  final SavedRoute savedRoute;

  const RoutePreview(this.savedRoute);
}

class _RoutePreviewController extends State<RoutePreview> {
  @override
  Widget build(BuildContext context) => _RoutePreviewView(this);

  MapController mapController;
  StatefulMapController statefulMapController;
  StreamSubscription mapStream;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    statefulMapController = StatefulMapController(mapController: mapController);
    mapStream =
        statefulMapController.changeFeed.listen((event) => setState(() {}));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    mapStream.cancel();
    super.dispose();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    //TODO: přidat do preview i vybrané waypointy
    statefulMapController.addMarker(
      name: 'start',
      marker: Marker(
          builder: (context) => const Icon(Icons.person_pin),
          height: 10,
          width: 10,
          point: widget.savedRoute.start.point),
    );
    statefulMapController.addMarker(
      name: 'end',
      marker: Marker(
          builder: (context) => const Icon(Icons.flag_rounded),
          height: 10,
          width: 10,
          point: widget.savedRoute.goal.point),
    );
    await statefulMapController.addLine(
        width: 1.5,
        //isDotted: true,
        color: Colors.pink,
        name: 'route',
        points: widget.savedRoute.latLngRoutePoints);
    await statefulMapController.fitLine('route');
  }
}

class _RoutePreviewView
    extends WidgetView<RoutePreview, _RoutePreviewController> {
  const _RoutePreviewView(_RoutePreviewController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: state.mapController,
      options: MapOptions(interactive: false),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayerOptions(markers: state.statefulMapController.markers),
        PolylineLayerOptions(polylines: state.statefulMapController.lines)
      ],
    );
  }
}
