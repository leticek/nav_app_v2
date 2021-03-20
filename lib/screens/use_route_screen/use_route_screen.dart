import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong/latlong.dart';
import 'package:map_controller/map_controller.dart';
import 'package:map_elevation/map_elevation.dart';
import 'package:navigation_app/resources/models/saved_route.dart';
import 'package:navigation_app/resources/providers.dart';
import 'package:navigation_app/resources/widget_view.dart';
import 'package:navigation_app/screens/use_route_screen/widgets/elevation_graph.dart';
import 'package:navigation_app/screens/use_route_screen/widgets/go_back_button.dart';
import 'package:navigation_app/screens/use_route_screen/widgets/show_graph.dart';
import 'package:navigation_app/screens/use_route_screen/widgets/start_navigation.dart';
import 'package:sizer/sizer.dart';

class UseRouteScreen extends StatefulWidget {
  const UseRouteScreen({Key key, this.routeToUse}) : super(key: key);

  @override
  _UseRouteScreenController createState() => _UseRouteScreenController();
  final SavedRoute routeToUse;
}

class _UseRouteScreenController extends State<UseRouteScreen> {
  @override
  Widget build(BuildContext context) => _UseRouteScreenView(this);

  MapController _mapController;
  StatefulMapController _statefulMapController;
  ElevationPoint hoverPoint;
  bool _showGraph = false;
  double showGraphButtonOffset = 1.2.h;
  bool dataTransferInProgress = false;

  void showGraph() => setState(() {
        if (_showGraph) {
          showGraphButtonOffset = 1.2.h;
        } else {
          showGraphButtonOffset = 20.0.h;
        }
        _showGraph = !_showGraph;
      });

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _statefulMapController =
        StatefulMapController(mapController: _mapController);
    _statefulMapController.changeFeed.listen((event) => setState(() {}));
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await _statefulMapController.addLine(
        color: Colors.red,
        name: 'route',
        points: widget.routeToUse.latLngRoutePoints);
    _statefulMapController.fitLine('route');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> startNavigation() async {
    setState(() {
      dataTransferInProgress = true;
    });
    final Map<String, dynamic> routeSteps = {
      'type': 'routeSteps',
      'data': widget.routeToUse.routeSteps.map((e) => e.toMap()).toList()
    };
    final Map<String, dynamic> routePoints = {
      'type': 'routePoints',
      'data': widget.routeToUse.latLngRoutePoints
          .map((e) => {
                'latitude': e.latitude,
                'longitude': e.longitude,
              })
          .toList()
    };
    final Map<String, dynamic> boundingBox = {
      'type': 'boundingBox',
      'data': widget.routeToUse.messageBoundingBox
    };
    context.read(watchConnectionProvider).startMessageChannel();

    context.read(watchConnectionProvider).sendMessage(routeSteps);
    await Future.delayed(const Duration(seconds: 15), () {});
    context.read(watchConnectionProvider).sendMessage(routePoints);
    await Future.delayed(const Duration(seconds: 15), () {});
    context.read(watchConnectionProvider).sendMessage(boundingBox);

    setState(() {
      dataTransferInProgress = false;
    });
  }

  bool onElevationNotification(ElevationHoverNotification notification) {
    setState(() => hoverPoint = notification.position);
    return true;
  }
}

class _UseRouteScreenView
    extends WidgetView<UseRouteScreen, _UseRouteScreenController> {
  const _UseRouteScreenView(_UseRouteScreenController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            FlutterMap(
              mapController: state._statefulMapController.mapController,
              options: MapOptions(
                interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                zoom: 5,
                center: LatLng(49.761752, 15.427551),
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayerOptions(markers: [
                  if (state.hoverPoint is LatLng)
                    Marker(
                      point: state.hoverPoint,
                      width: 10,
                      height: 10,
                      builder: (BuildContext context) => Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    )
                ]),
                PolylineLayerOptions(
                    polylines: state._statefulMapController.lines)
              ],
            ),
            GoBackButton(),
            StartNavigationButton(
                inProgress: state.dataTransferInProgress,
                onTap: state.startNavigation,
                offset: state.showGraphButtonOffset),
            ShowGraphButton(
                onTap: state.showGraph, offset: state.showGraphButtonOffset),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 140,
              child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: state._showGraph
                      ? ElevationGraph(
                          onNotification: state.onElevationNotification,
                          points: state.widget.routeToUse.latLngRoutePoints,
                        )
                      : null),
            )
          ],
        ),
      ),
    );
  }
}
