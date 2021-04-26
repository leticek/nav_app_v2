import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../resources/enums.dart';
import '../../resources/providers.dart';
import '../../resources/utils/route_builder.dart';
import '../../resources/widget_view.dart';
import '../login_screen/widgets/auth_dialog.dart';

class Login extends StatefulWidget {
  @override
  _LoginController createState() => _LoginController();
}

class _LoginController extends State<Login> {
  @override
  Widget build(BuildContext context) => _LoginView(this);

  bool _authVisible = false;
  SelectedTab _selectedTab = SelectedTab.login;

  Future<void> _loginWithGoogle() async {
    if (!await context.read(authServiceProvider).signInWithGoogle()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.read(authServiceProvider).errorCode),
        ),
      );
    }
  }

  void _register() {
    setState(() {
      _authVisible = true;
      _selectedTab = SelectedTab.register;
    });
  }

  void _login() {
    setState(() {
      _authVisible = true;
      _selectedTab = SelectedTab.login;
    });
  }

  void _onAuthClose() {
    setState(() {
      _authVisible = false;
    });
  }
}

class _LoginView extends WidgetView<Login, _LoginController> {
  const _LoginView(_LoginController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.cyan,
              ),
              width: double.infinity,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                    height: 25.0.h,
                    width: 50.0.w,
                    child: Image.asset('assets/splash_logo.png')),
                Text(
                  'Správce tras',
                  style: TextStyle(fontSize: 45.0.sp),
                ),
                Text(
                  'Mějte své trasy u sebe',
                  style: TextStyle(color: Colors.white, fontSize: 12.0.sp),
                ),
                SizedBox(height: 5.0.h),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.black),
                          onPressed: state._login,
                          child: const Text(
                            'Mám účet',
                          ),
                        ),
                      ),
                      SizedBox(width: 2.6.w),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              primary: Colors.black,
                              backgroundColor: Colors.white),
                          onPressed: state._register,
                          child: const Text('Nemám účet'),
                          //borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                GoogleSignInButton(
                  text: 'Použít účet Google',
                  onPressed: state._loginWithGoogle,
                ),
                if (!state._authVisible)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: MaterialButton(
                      onPressed: () => Navigator.pushNamed(
                          context, AppRoutes.myRoutesOffline),
                      child: Text(
                        'Pokračovat offline',
                        style:
                            TextStyle(color: Colors.white, fontSize: 12.0.sp),
                      ),
                    ),
                  )
              ],
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: state._authVisible
                  ? Container(
                      color: Colors.black54,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: AuthDialog(
                          selectedTab: state._selectedTab,
                          onClose: state._onAuthClose,
                        ),
                      ),
                    )
                  : null,
            )
          ],
        ),
      ),
    );
  }
}
