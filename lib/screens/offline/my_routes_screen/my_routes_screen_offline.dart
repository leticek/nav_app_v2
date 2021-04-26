import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:sizer/sizer.dart';

import './widgets/route_widget_offline.dart';
import '../../../resources/models/saved_route.dart';
import '../../../resources/widget_view.dart';

class MyRoutesScreenOffline extends StatefulWidget {
  @override
  _MyRoutesScreenController createState() => _MyRoutesScreenController();
}

class _MyRoutesScreenController extends State<MyRoutesScreenOffline> {
  @override
  Widget build(BuildContext context) => _MyRoutesScreenView(this);

  List<SavedRoute> routes = [];
  StreamSubscription<Map<String, dynamic>> subscription;

  @override
  void initState() {
    loadRoutes();
    super.initState();
  }

  void loadRoutes() {
    final db = Localstore.instance;
    final stream = db.collection('routes').stream;
    routes.clear();
    subscription = stream.listen((event) {
      setState(() {
        final savedRoute = SavedRoute.fromLocalstoreMap(event);
        routes.add(savedRoute);
      });
    });
  }

  SliverList _buildSlivers() {
    //loadRoutes();

    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (context, index) => routes.isEmpty
              ? Center(
                  heightFactor: 29,
                  widthFactor: 2,
                  child: Text(
                    'Nemáte uložené žádné trasy',
                    style: TextStyle(
                        fontSize: 14.0.sp, fontWeight: FontWeight.w500),
                  ))
              : RouteWidgetOffline(routes[index], UniqueKey()),
          childCount: routes.isEmpty ? 1 : routes.length),
    );
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}

class _MyRoutesScreenView
    extends WidgetView<MyRoutesScreenOffline, _MyRoutesScreenController> {
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
        state._buildSlivers(),
      ]),
    );
  }
}
