import 'package:flutter/material.dart';
import 'package:navigation_app/resources/providers/providers.dart';
import 'package:navigation_app/resources/route_builders/scale_transition.dart';
import 'package:navigation_app/resources/views/widget_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigation_app/screens/new_route_screen/new_route_screen.dart';
import 'package:navigation_app/services/auth.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenController createState() => _HomeScreenController();
}

class _HomeScreenController extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) => _HomeScreenView(this);
  AuthService _authService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authService = context.read(authServiceProvider);
  }
}

class _HomeScreenView extends WidgetView<HomeScreen, _HomeScreenController> {
  _HomeScreenView(_HomeScreenController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        body: Container(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  width: SizerUtil.orientation == Orientation.portrait
                      ? 45.0.w
                      : 40.0.h,
                  height: SizerUtil.orientation == Orientation.portrait
                      ? 40.0.h
                      : 45.0.w,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(35)),
                ),

                Container(
                  margin: EdgeInsets.all(5),
                  width: SizerUtil.orientation == Orientation.portrait
                      ? 45.0.w
                      : 40.0.h,
                  height: SizerUtil.orientation == Orientation.portrait
                      ? 40.0.h
                      : 45.0.w,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(35)),
                ),
              ],
            ),
            SizedBox(
              height: SizerUtil.orientation == Orientation.portrait ? 25 : 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: SizerUtil.orientation == Orientation.portrait
                      ? 45.0.w
                      : 40.0.h,
                  height: SizerUtil.orientation == Orientation.portrait
                      ? 40.0.h
                      : 45.0.w,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(35)),
                ),

                Container(
                  width: SizerUtil.orientation == Orientation.portrait
                      ? 45.0.w
                      : 40.0.h,
                  height: SizerUtil.orientation == Orientation.portrait
                      ? 40.0.h
                      : 45.0.w,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(35)),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
