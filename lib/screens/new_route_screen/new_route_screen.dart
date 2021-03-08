import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geojson/geojson.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:map_controller/map_controller.dart';
import 'package:navigation_app/resources/models/named_point.dart';
import 'package:navigation_app/resources/models/new_route.dart';
import 'package:navigation_app/resources/providers.dart';
import 'package:navigation_app/resources/utils/debouncer.dart';
import 'package:navigation_app/screens/new_route_screen/widgets/gpx_import_button.dart';
import 'package:navigation_app/screens/new_route_screen/widgets/hide_form_button.dart';
import 'package:navigation_app/screens/new_route_screen/widgets/input_field.dart';
import 'package:navigation_app/screens/new_route_screen/widgets/map.dart';
import 'package:navigation_app/screens/new_route_screen/widgets/save_route_button.dart';
import 'package:navigation_app/screens/new_route_screen/widgets/search_button.dart';
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
  NewRoute _currentRoute;
  List<Map<String, LatLng>> _lastPoints = [];
  Position _currentPosition;

  Marker _makeMarker({@required LatLng position, @required IconData iconData}) {
    return Marker(
      point: position,
      builder: (context) => Icon(iconData),
    );
  }

  @override
  void initState() {
    super.initState();
    _startController = TextEditingController();
    _goalController = TextEditingController();
    _debouncer = Debouncer();
    _startFocus = FocusNode();
    _goalFocus = FocusNode();
    _currentRoute = NewRoute();
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
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _statefulMapController.addMarker(
        marker: Marker(
            builder: (context) => Icon(Icons.person),
            height: 10,
            width: 10,
            point:
                LatLng(_currentPosition.latitude, _currentPosition.longitude)),
        name: 'currentLoaction');
  }

  @override
  void dispose() {
    super.dispose();
    _startController.dispose();
    _goalController.dispose();
    _startFocus.dispose();
    _goalFocus.dispose();
  }

  void _showHintList() {
    setState(() {
      _inputVisible = !_inputVisible;
      _startFocus.requestFocus();
      context.read(openRouteServiceProvider).clearList();
    });
  }

  void _textFieldChanged(String value) => _debouncer(
      () => context.read(openRouteServiceProvider).getSuggestion(value));

  void _addPlaceFromTap(LatLng point) async {
    final namedPoint = NamedPoint.fromPoint(point);
    if (_currentRoute.start == null) {
      _pointPicked(_startController, namedPoint, Icons.person_pin, 'start');
      _currentRoute.start = namedPoint;
      print(_currentRoute.start);
    } else if (_currentRoute.goal == null) {
      _pointPicked(_goalController, namedPoint, Icons.flag_rounded, 'goal');
      _currentRoute.goal = namedPoint;
    } else {
      _currentRoute.waypoints.add(point);
      _statefulMapController.addMarker(
          marker:
              _makeMarker(position: point, iconData: Icons.pin_drop_outlined),
          name: point.toString());
      _lastPoints.add({point.toString(): point});
    }
    _searchRoute();
  }

  void _removeLast() {
    final pointToRemove = _lastPoints.last;
    _lastPoints.removeLast();
    if (pointToRemove.containsKey('start')) {
      _currentRoute.start = null;
      _startController.text = '';
      _statefulMapController.removeMarker(name: 'start');
    } else if (pointToRemove.containsKey('goal')) {
      _currentRoute.goal = null;
      _goalController.text = '';
      _statefulMapController.removeMarker(name: 'goal');
    } else {
      _currentRoute.waypoints.removeLast();
      _statefulMapController.removeMarker(name: pointToRemove.keys.first);
    }

    _searchRoute();
  }

  void _suggestionPicked(NamedPoint namedPoint) async {
    if (_startFocus.hasFocus) {
      _pointPicked(_startController, namedPoint, Icons.person_pin, 'start');
      _currentRoute.start = namedPoint;
    } else {
      _pointPicked(_goalController, namedPoint, Icons.flag_rounded, 'goal');
      _currentRoute.goal = namedPoint;
    }
    _searchRoute();
  }

  void _pointPicked(TextEditingController controller, NamedPoint pickedPoint,
      IconData icon, String markerName) {
    controller.text = pickedPoint.name;
    _statefulMapController.addMarker(
        marker: _makeMarker(position: pickedPoint.point, iconData: icon),
        name: markerName);
    _lastPoints.add({markerName: pickedPoint.point});
    print(_lastPoints);
  }

  void _searchRoute() async {
    _statefulMapController.removeLine('route');
    if (_currentRoute.start != null && _currentRoute.goal != null) {
      final _result = await context
          .read(openRouteServiceProvider)
          .searchRoute(_currentRoute.getWaypoints());
      if (_result == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Stala se chyba.')));
        return;
      }
      _currentRoute.geoJson = GeoJson();
      await _currentRoute.geoJson.parse(_result);
      _statefulMapController.addLineFromGeoPoints(
          color: Colors.red,
          isDotted: true,
          name: 'route',
          geoPoints: _currentRoute.geoJson.lines[0].geoSerie.geoPoints);
      context.read(openRouteServiceProvider).setIsLoading();
      return;
    }
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
              onLongPress: state._removeLast,
            ),
          ),
          if (!state._inputVisible) GpxImportButton(),
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
                : SearchButton(onPressed: state._showHintList),
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