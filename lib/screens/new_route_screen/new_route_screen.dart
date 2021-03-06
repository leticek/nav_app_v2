import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import '../../resources/views/widget_view.dart';

class NewRouteScreen extends StatefulWidget {
  @override
  _NewRouteScreenController createState() => _NewRouteScreenController();
}

class _NewRouteScreenController extends State<NewRouteScreen> {
  @override
  Widget build(BuildContext context) => _NewRouteScreenView(this);

  bool _inputVisible = false;

  void _show() {
    setState(() {
      print(_inputVisible);
      print('eee');
      _inputVisible = !_inputVisible;
    });
  }
}

class _NewRouteScreenView
    extends WidgetView<NewRouteScreen, _NewRouteScreenController> {
  _NewRouteScreenView(_NewRouteScreenController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        !state._inputVisible ? Container() : Container(
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.cyan),
          child: IconButton(
            icon: Icon(Icons.arrow_circle_up, size: 25.0.sp,),
            onPressed: state._show,
          ),
        )
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
          GestureDetector(
            onVerticalDragDown: (details) => state._show(),
            child: Container(
              width: double.infinity,
              height: 20.0.h,
              color: Colors.transparent,
            ),
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 250),
            child: state._inputVisible
                ? Container(
              color: Colors.yellow,
              height: 100,
              width: 100.0.w,
              child: Form(child: TextFormField()),
            )
                : Row(mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.cyan),
                  margin: EdgeInsets.all(7),
                  child: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: state._show,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
