import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigation_app/screens/home_screen/widgets/button.dart';
import 'package:navigation_app/services/auth.dart';
import 'package:sizer/sizer.dart';

import 'file:///C:/Users/smiea/IdeaProjects/nav_app_v2/lib/resources/providers.dart';
import 'file:///C:/Users/smiea/IdeaProjects/nav_app_v2/lib/resources/utils/route_builder.dart';
import 'file:///C:/Users/smiea/IdeaProjects/nav_app_v2/lib/resources/widget_view.dart';

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

  void _goToNewRouteScreen() {
    Navigator.pushNamed(context, AppRoutes.newRoute);
  }
}

class _HomeScreenView extends WidgetView<HomeScreen, _HomeScreenController> {
  const _HomeScreenView(_HomeScreenController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.cyan,
            centerTitle: true,
            leading: Container(
                padding: const EdgeInsets.all(10),
                child: Image.asset('assets/splash_logo.png')),
            title: Text(
              'Hodinky připojeny',
              style: TextStyle(color: Colors.black, fontSize: 9.0.sp),
            ),
            actions: [
              IconButton(
                color: Colors.black,
                iconSize: 5.0.h,
                icon: const Icon(Icons.exit_to_app),
                onPressed: state._authService.signOut,
              )
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HomeScreenButton(
                    label: 'Nová trasa',
                    heroTag: 'newRoute',
                    icon: Icons.add_location_outlined,
                    onTap: state._goToNewRouteScreen,
                  ),
                  HomeScreenButton(
                    label: 'Moje trasy',
                    heroTag: 'myRoutes',
                    icon: Icons.map_outlined,
                    onTap: () => debugPrint('moje trasy'),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HomeScreenButton(
                    label: 'Nastavení',
                    heroTag: 'settings',
                    icon: Icons.settings_outlined,
                    onTap: () => debugPrint('nastavení'),
                  ),
                  HomeScreenButton(
                    label: 'Informace',
                    heroTag: 'about',
                    icon: Icons.info_outline,
                    onTap: () => debugPrint('info'),
                  )
                ],
              )
            ],
          )),
    );
  }
}
