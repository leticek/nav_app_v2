import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:map_controller/map_controller.dart';

import '../../../../resources/models/saved_route.dart';
import '../../../../resources/widget_view.dart';

class RoutePreviewOffline extends StatefulWidget {
  @override
  _RoutePreviewController createState() => _RoutePreviewController();

  final SavedRoute savedRoute;

  const RoutePreviewOffline(this.savedRoute);
}

class _RoutePreviewController extends State<RoutePreviewOffline> {
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
    mapStream.cancel();
    super.dispose();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    for (final waypoint in widget.savedRoute.waypoints) {
      statefulMapController.addMarker(
        name: waypoint.toString(),
        marker: Marker(
          anchorPos: AnchorPos.align(AnchorAlign.center),
          builder: (context) => const Icon(Icons.pin_drop_outlined),
          point: waypoint,
        ),
      );
    }
    statefulMapController
        .addLine(
            width: 1.8,
            color: Colors.pink,
            name: 'route',
            points: widget.savedRoute.latLngRoutePoints)
        .then((value) => statefulMapController.fitLine('route'));
  }
}

class _RoutePreviewView
    extends WidgetView<RoutePreviewOffline, _RoutePreviewController> {
  const _RoutePreviewView(_RoutePreviewController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: state.mapController,
      options: MapOptions(
        slideOnBoundaries: true,
        interactive: false,
      ),
      layers: [
        MarkerLayerOptions(markers: [
          Marker(
              builder: (context) => const Icon(Icons.person_pin),
              point: widget.savedRoute.start.point),
          Marker(
              builder: (context) => const Icon(Icons.flag_rounded),
              point: widget.savedRoute.goal.point),
          ...state.statefulMapController.markers
        ]),
        PolylineLayerOptions(polylines: state.statefulMapController.lines)
      ],
    );
  }
}
