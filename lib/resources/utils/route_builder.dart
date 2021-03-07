import 'package:flutter/material.dart';
import 'package:navigation_app/screens/home_screen/home_screen.dart';
import 'package:navigation_app/screens/login_screen/home.dart';
import 'package:navigation_app/screens/new_route_screen/new_route_screen.dart';

class AppRoutes {
  static const String auth = '/';
  static const String home = 'home';
  static const String newRoute = 'newRoute';
  static const String myRoutes = 'myRoutes';
  static const String about = 'about';
  static const String settings = 'settings';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
        settings: settings,
        builder: (_) {
          print(settings.name);
          switch (settings.name) {
            case auth:
              return AuthHome();
            case home:
              return HomeScreen();
            case newRoute:
              return NewRouteScreen();
            case myRoutes:
              return null;
            case about:
              return null;
            default:
              return null;
          }
        });
  }
}
