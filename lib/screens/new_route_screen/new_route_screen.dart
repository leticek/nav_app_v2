import 'package:flutter/material.dart';

class NewRouteScreen extends StatelessWidget {
  static final routeName = 'routeScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),
        body: Container(
      child: Text('new route'),
    ));
  }
}
