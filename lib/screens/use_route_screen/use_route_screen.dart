import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:map_controller/map_controller.dart';
import 'package:map_elevation/map_elevation.dart';
import 'package:navigation_app/resources/models/saved_route.dart';
import 'package:navigation_app/resources/widget_view.dart';
import 'package:navigation_app/screens/use_route_screen/widgets/go_back_button.dart';
import 'package:navigation_app/screens/use_route_screen/widgets/show_graph.dart';
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

  void showGrap() => setState(() {
        if (_showGraph) {
          showGraphButtonOffset = 1.2.h;
        }
        else{
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
                        width: 8,
                        height: 8,
                        builder: (BuildContext context) => Container(
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(8)),
                            ))
                ]),
                PolylineLayerOptions(polylines: [
                  Polyline(
                      points: state.widget.routeToUse.latLngRoutePoints,
                      color: Colors.red,
                      strokeWidth: 3)
                ])
              ],
            ),
            GoBackButton(),
            ShowGraphButton(
                onTap: state.showGrap, offset: state.showGraphButtonOffset),
            if (state._showGraph)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 140,
                child: NotificationListener<ElevationHoverNotification>(
                    onNotification: (ElevationHoverNotification notification) {
                      state.setState(() {
                        state.hoverPoint = notification.position;
                      });

                      return true;
                    },
                    child: Elevation(
                      state.widget.routeToUse.latLngRoutePoints,
                      color: Colors.grey,
                      elevationGradientColors: ElevationGradientColors(
                          gt10: Colors.green,
                          gt20: Colors.orangeAccent,
                          gt30: Colors.redAccent),
                    )),
              )
          ],
        ),
      ),
    );
  }
}
