import 'package:flutter/material.dart';
import 'package:navigation_app/resources/models/saved_route.dart';
import 'package:navigation_app/screens/edit_route_screen/edit_route_screen.dart';
import 'package:navigation_app/screens/home_screen/home_screen.dart';
import 'package:navigation_app/screens/login_screen/home.dart';
import 'package:navigation_app/screens/my_routes_screen/my_routes_screen.dart';
import 'package:navigation_app/screens/new_route_screen/new_route_screen.dart';
import 'package:navigation_app/screens/settings_screen/settings_screen.dart';

class AppRoutes {
  static const String auth = '/';
  static const String home = 'home';
  static const String newRoute = 'newRoute';
  static const String myRoutes = 'myRoutes';
  static const String about = 'about';
  static const String settingsScreen = 'settings';
  static const String editRoute = 'editRoute';

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
                routeToEdit: settings.arguments as SavedRoute,
              );
            case settingsScreen:
              return SettingsScreen();
            default:
              return null;
          }
        });
  }
}
