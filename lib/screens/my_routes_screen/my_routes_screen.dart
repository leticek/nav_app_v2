import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigation_app/resources/providers.dart';
import 'package:navigation_app/resources/widget_view.dart';

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
    debugPrint(
        context.read(authServiceProvider).userModel.savedRoutes.toString());
    return Container();
  }
}
