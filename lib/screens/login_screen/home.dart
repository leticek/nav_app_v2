import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigation_app/resources/enums.dart';
import 'package:navigation_app/resources/providers.dart';
import 'package:navigation_app/screens/home_screen/home_screen.dart';
import 'package:navigation_app/screens/login_screen/login_screen.dart';
import 'package:navigation_app/screens/login_screen/splash_screen.dart';

class AuthHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      final _authService = watch(authServiceProvider);
      print(_authService.status);
      switch (_authService.status) {
        case Status.Unauthenticated:
          return Login();
        case Status.Authenticated:
          return HomeScreen();
        case Status.Uninitialized:
          return SplashScreen();
        case Status.Authenticating:
          return Login();
        default:
          return Text('Default');
      }
    });
  }
}
