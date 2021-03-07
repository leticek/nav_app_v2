import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geojson/geojson.dart';
import 'package:latlong/latlong.dart';
import 'package:map_controller/map_controller.dart';
import 'package:navigation_app/resources/models/place_suggestion.dart';
import 'package:navigation_app/resources/providers.dart';
import 'package:navigation_app/resources/utils/debouncer.dart';
import 'package:navigation_app/screens/new_route_screen/widgets/hide_form_button.dart';
import 'package:navigation_app/screens/new_route_screen/widgets/input_field.dart';
import 'package:navigation_app/screens/new_route_screen/widgets/save_route_button.dart';
import 'package:navigation_app/screens/new_route_screen/widgets/search_hints.dart';
import 'package:sizer/sizer.dart';

import '../../resources/widget_view.dart';

class NewRouteScreen extends StatefulWidget {
  @override
  _NewRouteScreenController createState() => _NewRouteScreenController();
}

class _NewRouteScreenController extends State<NewRouteScreen> {
  @override
  Widget build(BuildContext context) => _NewRouteScreenView(this);

  bool _inputVisible = false;
  TextEditingController _startController;
  TextEditingController _goalController;
  Debouncer _debouncer;
  FocusNode _startFocus;
  FocusNode _goalFocus;
  MapController _mapController;
  StatefulMapController _statefulMapController;
  GeoJson _geoJson;

  @override
  void initState() {
    super.initState();
    _startController = TextEditingController();
    _goalController = TextEditingController();
    _debouncer = Debouncer();
    _startFocus = FocusNode();
    _goalFocus = FocusNode();
    _startFocus.addListener(() {
      if (!_startFocus.hasFocus)
        context.read(openRouteServiceProvider).clearList();
    });
    _goalFocus.addListener(() {
      if (!_goalFocus.hasFocus)
        context.read(openRouteServiceProvider).clearList();
    });
    _mapController = MapController();
    _statefulMapController =
        StatefulMapController(mapController: _mapController);
    _statefulMapController.changeFeed.listen((event) {
      setState(() {});
    });
    _geoJson = GeoJson();
  }

  @override
  void dispose() {
    super.dispose();
    _startController.dispose();
    _goalController.dispose();
    _startFocus.dispose();
    _goalFocus.dispose();
    _geoJson.dispose();
  }

  void _addPlaceFromTap(LatLng point) async {
    final place = PlaceSuggestion().toNamedPoint(point: point);
    if (context.read(newRouteProvider).start == null) {
      _startController.text = place.name;
      context.read(newRouteProvider).start = place;
      _statefulMapController.addMarker(
          marker: Marker(
            point: point,
            builder: (context) => Icon(Icons.person_pin),
          ),
          name: 'start');
    } else if (context.read(newRouteProvider).goal == null) {
      _goalController.text = place.name;
      context.read(newRouteProvider).goal = place;
      _statefulMapController.addMarker(
          marker: Marker(
            point: context.read(newRouteProvider).goal.point,
            builder: (context) => Icon(Icons.flag_rounded),
          ),
          name: 'goal');
    } else {
      context.read(newRouteProvider).waypoints.add(point);
      _statefulMapController.addMarker(
          marker: Marker(
            point: point,
            builder: (context) => Icon(Icons.pin_drop),
          ),
          name: point.toString());
    }
    await searchRoute();
  }

  void _showHintList() {
    setState(() {
      _inputVisible = !_inputVisible;
      context.read(openRouteServiceProvider).clearList();
    });
  }

  Future searchRoute() async {
    if (context.read(newRouteProvider).start != null &&
        context.read(newRouteProvider).goal != null) {
      final result = await context
          .read(openRouteServiceProvider)
          .searchRoute(context.read(newRouteProvider).getRoute());
      if (result != null) {
        await context.read(newRouteProvider).parseGeoJson(result);
        _statefulMapController.addLineFromGeoPoints(
            name: 'zkouska',
            geoPoints: context
                .read(newRouteProvider)
                .geoJson
                .lines[0]
                .geoSerie
                .geoPoints);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Bod se nepodařilo najít.')));
        context.read(newRouteProvider).waypoints.removeLast();
        _statefulMapController.markers.removeLast();
      }
    }
  }

  void _textFieldChanged(String value) => _debouncer(
      () => context.read(openRouteServiceProvider).getSuggestion(value));

  void _suggestionPicked(PlaceSuggestion placeSuggestion) async {
    if (_startFocus.hasFocus) {
      _startController.text = placeSuggestion.label;
      context.read(newRouteProvider).start = placeSuggestion.toNamedPoint();
      _statefulMapController.addMarker(
          marker: Marker(
            point: context.read(newRouteProvider).start.point,
            builder: (context) => Icon(Icons.person_pin),
          ),
          name: 'start');
    } else {
      _goalController.text = placeSuggestion.label;
      context.read(newRouteProvider).goal = placeSuggestion.toNamedPoint();
      _statefulMapController.addMarker(
          marker: Marker(
            point: context.read(newRouteProvider).goal.point,
            builder: (context) => Icon(Icons.flag_rounded),
          ),
          name: 'goal');
    }
    await searchRoute();
  }
}

class _NewRouteScreenView
    extends WidgetView<NewRouteScreen, _NewRouteScreenController> {
  _NewRouteScreenView(_NewRouteScreenController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            context.read(openRouteServiceProvider).clearList();
            context.read(newRouteProvider).clearRoute();
            FocusManager.instance.primaryFocus.unfocus();
            Navigator.of(context).pop();
          },
        ),
        actions: [
          !state._inputVisible
              ? Container()
              : HideFormButton(onTap: state._showHintList)
        ],
        centerTitle: true,
        backgroundColor: Colors.cyan,
        title: Hero(
          tag: 'newRoute',
          child: Icon(
            Icons.add_location_outlined,
            color: Colors.black,
            size: 30.0.sp,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            child: MyMap(
              controller: state._statefulMapController,
              onTap: state._addPlaceFromTap,
            ),
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 0),
            child: state._inputVisible
                ? Container(
                    color: Colors.white38,
                    height: 20.0.h,
                    width: 100.0.w,
                    child: ListView(
                      children: [
                        InputField(
                          key: Key('start-field'),
                          focusNode: state._startFocus,
                          textEditingController: state._startController,
                          label: 'Start',
                          onChanged: state._textFieldChanged,
                        ),
                        InputField(
                          key: Key('goal-field'),
                          focusNode: state._goalFocus,
                          textEditingController: state._goalController,
                          label: 'Cíl',
                          onChanged: state._textFieldChanged,
                        )
                      ],
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.black),
                        margin: EdgeInsets.all(10),
                        child: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          onPressed: state._showHintList,
                        ),
                      )
                    ],
                  ),
          ),
          if (!state._inputVisible) SaveRouteButton(),
          SearchHints(
            onTap: state._suggestionPicked,
          )
        ],
      ),
    );
  }
}

class MyMap extends StatelessWidget {
  const MyMap({controller, onTap})
      : _controller = controller,
        _onTap = onTap;

  final StatefulMapController _controller;
  final Function _onTap;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _controller.mapController,
      options: MapOptions(
        onTap: (latlng) => _onTap(latlng),
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
