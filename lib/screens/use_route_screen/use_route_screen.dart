import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:map_controller/map_controller.dart';
import 'package:navigation_app/resources/models/saved_route.dart';
import 'package:navigation_app/resources/widget_view.dart';
import 'package:navigation_app/screens/use_route_screen/widgets/go_back_button.dart';

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

  @override
  void initState() {
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
    print(state.widget.routeToUse.id);
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
                //MarkerLayerOptions(markers: _controller.markers),
                //PolylineLayerOptions(polylines: _controller.lines)
              ],
            ),
            GoBackButton()
          ],
        ),
      ),
    );
  }
}
