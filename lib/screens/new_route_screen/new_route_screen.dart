import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong/latlong.dart';
import 'package:navigation_app/resources/providers.dart';
import 'package:navigation_app/resources/utils/debouncer.dart';
import 'package:navigation_app/screens/new_route_screen/widgets/hide_form_button.dart';
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
  TextEditingController _test;
  Debouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _test = TextEditingController();
    _test.text = 'test';
    _debouncer = Debouncer();
  }

  void _show() {
    setState(() {
      _inputVisible = !_inputVisible;
      context.read(openRouteServiceProvider).clearList();
    });
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
            FocusManager.instance.primaryFocus.unfocus();
            Navigator.of(context).pop();
          },
        ),
        actions: [
          !state._inputVisible
              ? Container()
              : HideFormButton(onTap: state._show)
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
            child: FlutterMap(
              options: MapOptions(
                onTap: (latlng) => print(latlng),
                zoom: 5,
                center: LatLng(49.761752, 15.427551),
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                )
              ],
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
                        Container(
                          height: 9.0.h,
                          padding: const EdgeInsets.all(5),
                          child: TextField(
                            key: Key("start-field"),
                            controller: state._test,
                            decoration: InputDecoration(
                              labelText: 'Start',
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.cyan),
                              ),
                            ),
                            style: TextStyle(fontSize: 15.0.sp),
                            textInputAction: TextInputAction.next,
                            onChanged: (value) => state._debouncer(() => context
                                .read(openRouteServiceProvider)
                                .getSuggestion(value)),
                          ),
                        ),
                        Container(
                          height: 9.0.h,
                          padding: const EdgeInsets.all(5),
                          child: TextField(
                            key: Key("start-field"),
                            controller: state._test,
                            decoration: InputDecoration(
                              labelText: 'Cíl',
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.cyan),
                              ),
                            ),
                            style: TextStyle(fontSize: 15.0.sp),
                            textInputAction: TextInputAction.next,
                            onChanged: (value) => state._debouncer(() => context
                                .read(openRouteServiceProvider)
                                .getSuggestion(value)),
                          ),
                        )
                      ],
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.cyan),
                        margin: EdgeInsets.all(10),
                        child: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: state._show,
                        ),
                      )
                    ],
                  ),
          ),
          if (!state._inputVisible) SaveRouteButton(),
          SearchHints()
        ],
      ),
    );
  }
}
