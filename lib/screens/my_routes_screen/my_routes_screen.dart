import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigation_app/resources/models/saved_route.dart';
import 'package:navigation_app/resources/providers.dart';
import 'package:navigation_app/resources/widget_view.dart';
import 'package:navigation_app/screens/my_routes_screen/widgets/route_preview.dart';
import 'package:sizer/sizer.dart';

class MyRoutesScreen extends StatefulWidget {
  @override
  _MyRoutesScreenController createState() => _MyRoutesScreenController();
}

class _MyRoutesScreenController extends State<MyRoutesScreen> {
  @override
  Widget build(BuildContext context) => _MyRoutesScreenView(this);

  Widget _buildItem(SavedRoute savedRoute) {
    return InkWell(
      splashColor: Colors.cyan,
      onTap: () {},
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.cyan,
            ),
            margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            height: 25.0.h,
          ),
          Positioned(
            left: 5.0.w,
            top: 1.7.h,
            right: 5.0.w,
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: 1.5),
              ),
              height: 16.0.h,
              child: RoutePreview(savedRoute),
            ),
          ),
          Positioned(
            left: 5.0.w,
            bottom: 1.7.h,
            right: 27.0.w,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.green,
              ),
              height: 6.0.h,
            ),
          ),
          Positioned(
            left: 74.5.w,
            bottom: 1.7.h,
            right: 5.0.w,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.yellow,
              ),
              height: 6.0.h,
            ),
          ),
        ],
      ),
    );
  }
}

class _MyRoutesScreenView
    extends WidgetView<MyRoutesScreen, _MyRoutesScreenController> {
  const _MyRoutesScreenView(_MyRoutesScreenController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Hero(
          tag: 'myRoutes',
          child: Icon(
            Icons.map_outlined,
            color: Colors.black,
            size: 30.0.sp,
          ),
        ),
      ),
      body: Center(
          child: Consumer(
        builder: (context, watch, child) => ListView.builder(
          itemCount: watch(authServiceProvider).userModel.savedRoutes.length,
          itemBuilder: (context, index) => state._buildItem(
              watch(authServiceProvider).userModel.savedRoutes[index]),
        ),
      )),
    );
  }
}
