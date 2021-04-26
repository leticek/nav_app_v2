import 'package:flutter/material.dart';

import '../../screens/edit_route_screen/edit_route_screen.dart';
import '../../screens/home_screen/home_screen.dart';
import '../../screens/login_screen/home.dart';
import '../../screens/my_routes_screen/my_routes_screen.dart';
import '../../screens/new_route_screen/new_route_screen.dart';
import '../../screens/offline/my_routes_screen/my_routes_screen_offline.dart';
import '../../screens/offline/use_route_screen/use_route_screen_offline.dart';
import '../../screens/settings_screen/settings_screen.dart';
import '../../screens/use_route_screen/use_route_screen.dart';
import '../models/saved_route.dart';

class AppRoutes {
  static const String auth = '/';
  static const String home = 'home';
  static const String newRoute = 'newRoute';
  static const String myRoutes = 'myRoutes';
  static const String about = 'about';
  static const String settingsScreen = 'settings';
  static const String editRoute = 'editRoute';
  static const String useRoute = 'useRoute';
  static const String myRoutesOffline = 'myRoutesOffline';
  static const String useRouteOffline = 'useRouteOffline';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
        settings: settings,
        builder: (_) {
          switch (settings.name) {
            case auth:
              return AuthHome();
            case home:
              return HomeScreen();
            case newRoute:
              return NewRouteScreen();
            case myRoutes:
              return MyRoutesScreen();
            case about:
              return null;
            case editRoute:
              return EditRouteScreen(
                  routeToEdit: settings.arguments as SavedRoute);
            case settingsScreen:
              return SettingsScreen();
            case useRoute:
              return UseRouteScreen(
                  routeToUse: settings.arguments as SavedRoute);
            case myRoutesOffline:
              return MyRoutesScreenOffline();
            case useRouteOffline:
              return UseRouteScreenOffline(
                  routeToUse: settings.arguments as SavedRoute);
            default:
              return null;
          }
        });
  }
}
