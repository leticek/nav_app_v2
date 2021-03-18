import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geojson/geojson.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:map_controller/map_controller.dart';
import 'package:navigation_app/resources/models/named_point.dart';
import 'package:navigation_app/resources/models/new_route.dart';
import 'package:navigation_app/resources/models/saved_route.dart';
import 'package:navigation_app/resources/providers.dart';
import 'package:navigation_app/resources/utils/debouncer.dart';
import 'package:navigation_app/resources/widget_view.dart';
import 'package:navigation_app/screens/edit_route_screen/widgets/leave_dialog.dart';
import 'package:navigation_app/screens/new_route_screen/widgets/hide_form_button.dart';
import 'package:navigation_app/screens/new_route_screen/widgets/input_field.dart';
import 'package:navigation_app/screens/new_route_screen/widgets/map.dart';
import 'package:navigation_app/screens/new_route_screen/widgets/save_route_button.dart';
import 'package:navigation_app/screens/new_route_screen/widgets/search_button.dart';
import 'package:navigation_app/screens/new_route_screen/widgets/search_hints.dart';
import 'package:sizer/sizer.dart';

class EditRouteScreen extends StatefulWidget {
  const EditRouteScreen({Key key, this.routeToEdit}) : super(key: key);

  @override
  _EditRouteScreenController createState() => _EditRouteScreenController();

  final SavedRoute routeToEdit;
}

class _EditRouteScreenController extends State<EditRouteScreen> {
  @override
  Widget build(BuildContext context) => _EditRouteScreenView(this);

  bool _inputVisible = false;
  TextEditingController _startController;
  TextEditingController _goalController;
  FocusNode _startFocus;
  FocusNode _goalFocus;
  StatefulMapController _statefulMapController;
  MapController _mapController;
  NewRoute _newRoute;
  Debouncer _debouncer;
  Position _currentPosition;
  List<Map<String, LatLng>> _history = [];

  @override
  void initState() {
    super.initState();
    debugPrint(widget.routeToEdit.toString());
    _debouncer = Debouncer();
    _startController = TextEditingController();
    _goalController = TextEditingController();
    _newRoute = NewRoute.fromSavedRoute(widget.routeToEdit);
    _history = List.from(widget.routeToEdit.history);
    _goalFocus = FocusNode();
    _startFocus = FocusNode();
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
    _startController.text = _newRoute.start.name;
    _goalController.text = _newRoute.goal.name;

    for (final entry in _history) {
      final namedPoint = NamedPoint.fromPoint(entry.values.first);
      if (entry.containsKey('start')) {
        _addPointFromHistory(
            _startController, namedPoint, Icons.person_pin, 'start');
      } else if (entry.containsKey('goal')) {
        _addPointFromHistory(
            _goalController, namedPoint, Icons.flag_rounded, 'goal');
      } else {
        _statefulMapController.addMarker(
            marker: _makeMarker(
                position: entry.values.first,
                iconData: Icons.pin_drop_outlined),
            name: entry.values.first.toString());
      }
    }

    await _statefulMapController.addLine(
        color: Colors.red,
        isDotted: true,
        name: 'route',
        points: widget.routeToEdit.latLngRoutePoints);

    _statefulMapController.fitLine('route');
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
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
  }

  Future<void> _suggestionPicked(NamedPoint namedPoint) async {
    //TODO: fix odebrání z historie po vybrání z našeptávače
    if (_startFocus.hasFocus) {
      _pointPicked(_startController, namedPoint, Icons.person_pin, 'start');
      _newRoute.start = namedPoint;
    } else {
      _pointPicked(_goalController, namedPoint, Icons.flag_rounded, 'goal');
      _newRoute.goal = namedPoint;
    }
    _searchRoute();
  }

  Future<void> _saveRoute() async {
    setState(() {
      context.read(openRouteServiceProvider).isLoading = true;
    });
    if (await context.read(firestoreProvider).updateRoute(
        SavedRoute(
          id: widget.routeToEdit.id,
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
      Navigator.of(context).pop(true);
      return;
    }
    setState(() {
      context.read(openRouteServiceProvider).isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Chyba. Zkuste to později.'),
    ));
  }

  void _showHintList() {
    setState(() {
      _inputVisible = !_inputVisible;
      _startFocus.requestFocus();
      context.read(openRouteServiceProvider).clearList();
    });
  }

  Marker _makeMarker({@required LatLng position, @required IconData iconData}) {
    return Marker(
      point: position,
      builder: (context) => Icon(iconData),
    );
  }

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

  Future<void> _searchRoute() async {
    _statefulMapController.removeLine('route');
    if (_newRoute.start != null && _newRoute.goal != null) {
      final _result = await context
          .read(openRouteServiceProvider)
          .searchRoute(_newRoute.getWaypoints());
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
      _statefulMapController.addLineFromGeoPoints(
          color: Colors.red,
          isDotted: true,
          name: 'route',
          geoPoints: _newRoute.geoJson.lines[0].geoSerie.geoPoints);
      context.read(openRouteServiceProvider).setIsLoading();
      return;
    }
  }

  void _addPointFromHistory(TextEditingController controller,
      NamedPoint pickedPoint, IconData icon, String markerName) {
    controller.text = pickedPoint.name;
    _statefulMapController.addMarker(
        marker: _makeMarker(position: pickedPoint.point, iconData: icon),
        name: markerName);
  }

  void _pointPicked(TextEditingController controller, NamedPoint pickedPoint,
      IconData icon, String markerName) {
    controller.text = pickedPoint.name;
    _statefulMapController.addMarker(
        marker: _makeMarker(position: pickedPoint.point, iconData: icon),
        name: markerName);
    _history.add({markerName: pickedPoint.point});
  }

  void _textFieldChanged(String value) => _debouncer(
      () => context.read(openRouteServiceProvider).getSuggestion(value));

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

  Future<void> _goBack() async {
    if (await showDialog(
      context: context,
      builder: (context) => const LeaveConfirmation(),
    )) {
      context.read(openRouteServiceProvider).clearList();
      FocusManager.instance.primaryFocus.unfocus();
      Navigator.of(context).pop(false);
    }
  }
}

class _EditRouteScreenView
    extends WidgetView<EditRouteScreen, _EditRouteScreenController> {
  const _EditRouteScreenView(_EditRouteScreenController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: state._goBack),
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
