import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import './widgets/button.dart';
import '../../resources/providers.dart';
import '../../resources/utils/route_builder.dart';
import '../../resources/widget_view.dart';
import '../../services/auth.dart';

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

  void _goToNewRouteScreen() =>
      Navigator.pushNamed(context, AppRoutes.newRoute);

  void _goToSettingsScreen() =>
      Navigator.pushNamed(context, AppRoutes.settingsScreen);

  void _goToMyRoutesScreen() =>
      Navigator.pushNamed(context, AppRoutes.myRoutes);
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
