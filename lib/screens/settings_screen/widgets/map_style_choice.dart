import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:map_controller/map_controller.dart';
import 'package:navigation_app/resources/widget_view.dart';
import 'package:sizer/sizer.dart';

class MapStyleChoice extends StatefulWidget {
  final String title;
  final TileLayerOptions options;

  const MapStyleChoice({Key key, this.title, this.options}) : super(key: key);

  @override
  _MapStyleChoiceController createState() => _MapStyleChoiceController();
}

class _MapStyleChoiceController extends State<MapStyleChoice> {
  @override
  Widget build(BuildContext context) => _MapStyleChoiceView(this);

  MapController _mapController;
  StatefulMapController _statefulMapController;
  StreamSubscription sub;
  Position _currentPosition;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _statefulMapController =
        StatefulMapController(mapController: _mapController);
    sub = _statefulMapController.changeFeed.listen((event) => setState(() {}));
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _statefulMapController.centerOnPoint(
        LatLng(_currentPosition.latitude, _currentPosition.longitude));
    _statefulMapController.zoomTo(14);
  }

  @override
  void dispose() {
    super.dispose();
    sub.cancel();
  }
}

class _MapStyleChoiceView
    extends WidgetView<MapStyleChoice, _MapStyleChoiceController> {
  const _MapStyleChoiceView(_MapStyleChoiceController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(width: 18.0.w, child: Center(child: Text(widget.title))),
          SizedBox(
            width: 45.0.w,
            height: 10.0.h,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1.5),
              ),
              height: 19.0.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FlutterMap(
                  mapController: state._mapController,
                  options: MapOptions(
                    interactive: false,
                    zoom: 5,
                    center: LatLng(49.761752, 15.427551),
                  ),
                  layers: [widget.options],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
