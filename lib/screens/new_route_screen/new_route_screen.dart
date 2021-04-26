import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geojson/geojson.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gpx/gpx.dart';
import 'package:latlong/latlong.dart';
import 'package:map_controller/map_controller.dart';
import 'package:sizer/sizer.dart';

import './widgets/gpx_import_button.dart';
import './widgets/hide_form_button.dart';
import './widgets/input_field.dart';
import './widgets/map.dart';
import './widgets/save_route_button.dart';
import './widgets/search_button.dart';
import './widgets/search_hints.dart';
import '../../resources/models/named_point.dart';
import '../../resources/models/new_route.dart';
import '../../resources/models/saved_route.dart';
import '../../resources/providers.dart';
import '../../resources/utils/debouncer.dart';
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
  NewRoute _newRoute;
  final List<Map<String, LatLng>> _history = [];
  Position _currentPosition;

  Future<void> _saveRoute() async {
    setState(() {
      context.read(openRouteServiceProvider).isLoading = true;
    });
    if (_newRoute.start == null || _newRoute.goal == null) {
      setState(() {
        context.read(openRouteServiceProvider).isLoading = false;
      });
      return;
    }
    if (await context.read(firestoreProvider).saveNewRoute(
        SavedRoute(
          start: _newRoute.start,
          goal: _newRoute.goal,
          waypoints: _newRoute.waypoints,
          history: _history,
          routeGeoJsonString: _newRoute.geoJsonString,
        ),
        context.read(authServiceProvider).userModel.userId)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Trasa úspěšně uložena.'),
      ));
      setState(() {
        context.read(openRouteServiceProvider).isLoading = false;
      });
      return;
    }
    setState(() {
      context.read(openRouteServiceProvider).isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Chyba. Zkuste to později.'),
    ));
  }

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
    _newRoute = NewRoute();
    _startFocus.addListener(() {
      if (!_startFocus.hasFocus) {
        context.read(openRouteServiceProvider).clearList();
      }
    });
    _goalFocus.addListener(() {
      if (!_goalFocus.hasFocus) {
        context.read(openRouteServiceProvider).clearList();
      }
    });
    _mapController = MapController();
    _statefulMapController =
        StatefulMapController(mapController: _mapController);
    _statefulMapController.changeFeed.listen((event) {
      setState(() {});
    });
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _statefulMapController.centerOnPoint(
        LatLng(_currentPosition.latitude, _currentPosition.longitude));
    _statefulMapController.zoomTo(14);
    _statefulMapController.addMarker(
        marker: Marker(
            builder: (context) => const Icon(Icons.person),
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

  Future<void> _addPlaceFromTap(LatLng point) async {
    final namedPoint = NamedPoint.fromPoint(point);
    if (_newRoute.start == null) {
      _pointPicked(_startController, namedPoint, Icons.person_pin, 'start');
      _newRoute.start = namedPoint;
      debugPrint(_newRoute.start.toString());
    } else if (_newRoute.goal == null) {
      _pointPicked(_goalController, namedPoint, Icons.flag_rounded, 'goal');
      _newRoute.goal = namedPoint;
    } else {
      _newRoute.waypoints.add(point);
      _statefulMapController.addMarker(
          marker:
              _makeMarker(position: point, iconData: Icons.pin_drop_outlined),
          name: point.toString());
      _history.add({point.toString(): point});
    }
    _searchRoute();
  }

  void _removeLast() {
    if (context.read(openRouteServiceProvider).isLoading) return;
    final pointToRemove = _history.last;
    _history.removeLast();
    if (pointToRemove.containsKey('start')) {
      _newRoute.start = null;
      _startController.text = '';
      _statefulMapController.removeMarker(name: 'start');
    } else if (pointToRemove.containsKey('goal')) {
      _newRoute.goal = null;
      _goalController.text = '';
      _statefulMapController.removeMarker(name: 'goal');
    } else {
      _newRoute.waypoints.removeLast();
      _statefulMapController.removeMarker(name: pointToRemove.keys.first);
    }

    _searchRoute();
  }

  Future<void> _suggestionPicked(NamedPoint namedPoint) async {
    if (_startFocus.hasFocus) {
      _pointPicked(_startController, namedPoint, Icons.person_pin, 'start');
      _newRoute.start = namedPoint;
    } else {
      _pointPicked(_goalController, namedPoint, Icons.flag_rounded, 'goal');
      _newRoute.goal = namedPoint;
    }
    _searchRoute();
  }

  void _pointPicked(TextEditingController controller, NamedPoint pickedPoint,
      IconData icon, String markerName) {
    controller.text = pickedPoint.name;
    _statefulMapController.addMarker(
        marker: _makeMarker(position: pickedPoint.point, iconData: icon),
        name: markerName);
    _history.add({markerName: pickedPoint.point});
  }

  Future<void> _searchRoute({List<dynamic> points}) async {
    _statefulMapController.removeLine('route');
    if (_newRoute.start != null && _newRoute.goal != null) {
      final _result = await context
          .read(openRouteServiceProvider)
          .searchRoute(points ?? _newRoute.getWaypoints());
      if (_result == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Stala se chyba.'),
        ));
        context.read(openRouteServiceProvider).setIsLoading();
        return;
      }
      _newRoute.geoJsonString = _result;
      _newRoute.geoJson = GeoJson();
      await _newRoute.geoJson.parse(_result);
      await _statefulMapController.addLineFromGeoPoints(
          color: Colors.red,
          isDotted: true,
          name: 'route',
          geoPoints: _newRoute.geoJson.lines[0].geoSerie.geoPoints);
      context.read(openRouteServiceProvider).setIsLoading();
      _statefulMapController.fitLine('route');
      return;
    }
  }

  Future loadGpx() async {
    final pickedFile =
        await FilePicker.platform.pickFiles(allowMultiple: false);
    if (pickedFile == null) {
      return;
    }
    if (pickedFile.files.first.extension != 'gpx') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Vyberte prosím .GPX soubor.'),
      ));
      return;
    }
    final gpxFile = File(pickedFile.files.first.path);
    final parsedGpx = GpxReader().fromString(gpxFile.readAsStringSync());

    if (parsedGpx.trks.isNotEmpty) {
      final start = parsedGpx.trks.first.trksegs.first.trkpts.first;
      final end = parsedGpx.trks.first.trksegs.last.trkpts.last;

      _pointPicked(
          _startController,
          NamedPoint.fromPoint(LatLng(start.lat, start.lon)),
          Icons.person_pin,
          'start');
      _pointPicked(
          _goalController,
          NamedPoint.fromPoint(LatLng(end.lat, end.lon)),
          Icons.flag_rounded,
          'goal');

      _newRoute.start = NamedPoint.fromPoint(LatLng(start.lat, start.lon));
      _newRoute.goal = NamedPoint.fromPoint(LatLng(end.lat, end.lon));

      final points = parsedGpx.trks.first.trksegs.first.trkpts
          .map((e) => [e.lon, e.lat])
          .toList();
      points.length <= 50 ? _searchRoute(points: points) : _searchRoute();
    } else {
      final start = parsedGpx.wpts.first;
      final end = parsedGpx.wpts.last;
      _pointPicked(
          _startController,
          NamedPoint.fromPoint(LatLng(start.lat, start.lon)),
          Icons.person_pin,
          'start');
      _pointPicked(
          _goalController,
          NamedPoint.fromPoint(LatLng(end.lat, end.lon)),
          Icons.flag_rounded,
          'goal');
      _newRoute.start = NamedPoint.fromPoint(LatLng(start.lat, start.lon));
      _newRoute.goal = NamedPoint.fromPoint(LatLng(end.lat, end.lon));
      final points = parsedGpx.wpts.map((e) => [e.lon, e.lat]).toList();
      points.length <= 50 ? _searchRoute(points: points) : _searchRoute();
    }
  }
}

class _NewRouteScreenView
    extends WidgetView<NewRouteScreen, _NewRouteScreenController> {
  const _NewRouteScreenView(_NewRouteScreenController state) : super(state);

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
          if (!state._inputVisible)
            Container()
          else
            HideFormButton(state._showHintList)
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
          MyMap(
            controller: state._statefulMapController,
            onTap: state._addPlaceFromTap,
            onLongPress: state._removeLast,
          ),
          if (!state._inputVisible)
            GpxImportButton(
              onPressed: state.loadGpx,
            ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 1),
            child: state._inputVisible
                ? Container(
                    color: Colors.white38,
                    height: 20.0.h,
                    width: 100.0.w,
                    child: ListView(
                      children: [
                        InputField(
                          key: const Key('start-field'),
                          focusNode: state._startFocus,
                          textEditingController: state._startController,
                          label: 'Start',
                          onChanged: state._textFieldChanged,
                        ),
                        InputField(
                          key: const Key('goal-field'),
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
          if (!state._inputVisible) SaveRouteButton(onTap: state._saveRoute),
          SearchHints(
            onTap: state._suggestionPicked,
          )
        ],
      ),
    );
  }
}
