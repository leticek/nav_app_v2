import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'file:///C:/Users/smiea/IdeaProjects/nav_app_v2/lib/resources/enums.dart';
import 'file:///C:/Users/smiea/IdeaProjects/nav_app_v2/lib/resources/providers.dart';
import 'file:///C:/Users/smiea/IdeaProjects/nav_app_v2/lib/resources/widget_view.dart';
import 'package:navigation_app/screens/login_screen/widgets/auth_dialog.dart';
import 'package:sizer/sizer.dart';

class Login extends StatefulWidget {
  @override
  _LoginController createState() => _LoginController();
}

class _LoginController extends State<Login> {
  @override
  Widget build(BuildContext context) => _LoginView(this);

  bool _authVisible = false;
  SelectedTab _selectedTab = SelectedTab.Login;

  void _loginWithGoogle() async {
    await context.read(authServiceProvider).signInWithGoogle();
  }

  void _register() {
    setState(() {
      _authVisible = true;
      _selectedTab = SelectedTab.Register;
    });
  }

  void _login() {
    setState(() {
      _authVisible = true;
      _selectedTab = SelectedTab.Login;
    });
  }

  void _onAuthClose() {
    setState(() {
      _authVisible = false;
    });
  }
}

class _LoginView extends WidgetView<Login, _LoginController> {
  _LoginView(_LoginController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.cyan,
              ),
              width: double.infinity,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
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
                          child: Text(
                            'Mám účet',
                          ),
                          onPressed: state._login,
                        ),
                      ),
                      SizedBox(width: 2.6.w),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            primary: Colors.black,
                            side: BorderSide(color: Colors.black),
                          ),
                          child: Text('Nemám účet'),
                          onPressed: state._register,
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
              ],
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
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
