import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigation_app/resources/providers.dart';
import 'package:navigation_app/resources/widget_view.dart';
import 'package:navigation_app/screens/my_routes_screen/widgets/route_widget.dart';
import 'package:sizer/sizer.dart';

class MyRoutesScreen extends StatefulWidget {
  @override
  _MyRoutesScreenController createState() => _MyRoutesScreenController();
}

class _MyRoutesScreenController extends State<MyRoutesScreen> {
  @override
  Widget build(BuildContext context) => _MyRoutesScreenView(this);
}

class _MyRoutesScreenView
    extends WidgetView<MyRoutesScreen, _MyRoutesScreenController> {
  const _MyRoutesScreenView(_MyRoutesScreenController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          floating: true,
          backgroundColor: Colors.cyan,
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
        Consumer(
          builder: (context, watch, child) {
            final service = watch(authServiceProvider);
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      RouteWidget(service.userModel.savedRoutes[index]),
                  childCount: service.userModel.savedRoutes?.length ??= 0),
            );
          },
        )
      ]),
    );
  }
}
