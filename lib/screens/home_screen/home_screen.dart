import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigation_app/resources/providers.dart';
import 'package:navigation_app/resources/utils/route_builder.dart';
import 'package:navigation_app/resources/widget_view.dart';
import 'package:navigation_app/screens/home_screen/widgets/button.dart';
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
    super.initState();
    _authService = context.read(authServiceProvider);
  }

  void _goToNewRouteScreen() {
    Navigator.pushNamed(context, AppRoutes.newRoute);
  }

  void _goToSettingsScreen() {
    Navigator.pushNamed(context, AppRoutes.settingsScreen);
  }

  void _goToMyRoutesScreen() {
    Navigator.pushNamed(context, AppRoutes.myRoutes);
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
            leading: Consumer(
              builder: (context, watch, child) {
                return watch(watchConnectionProvider).appStartStatus.isEmpty
                    ? InkWell(
                        onTap: context.read(watchConnectionProvider).openApp,
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset('assets/splash_logo.png')),
                      )
                    : Center(
                      child: Text(
                          watch(watchConnectionProvider).appStartStatus,
                          style: TextStyle(fontSize: 9.0.sp, fontWeight: FontWeight.w700),
                        ),
                    );
              },
            ),
            title: Consumer(
              builder: (context, watch, child) => Text(
                watch(watchConnectionProvider).watchStatus,
                style: TextStyle(color: Colors.black, fontSize: 9.0.sp),
              ),
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
                    onTap: state._goToMyRoutesScreen,
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
                    onTap: state._goToSettingsScreen,
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
