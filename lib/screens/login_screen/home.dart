import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../resources//providers.dart';
import '../../resources/enums.dart';
import '../home_screen/home_screen.dart';
import '../login_screen/login_screen.dart';
import '../login_screen/splash_screen.dart';

class AuthHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      final _authService = watch(authServiceProvider);
      switch (_authService.status as AuthStatus) {
        case AuthStatus.unauthenticated:
          return Login();
        case AuthStatus.authenticated:
          return HomeScreen();
        case AuthStatus.uninitialized:
          return SplashScreen();
        case AuthStatus.authenticating:
          return Login();
        default:
          return Login();
      }
    });
  }
}
