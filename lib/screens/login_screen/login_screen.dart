import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigation_app/resources/enums/enums.dart';
import 'package:navigation_app/resources/providers/providers.dart';
import 'package:navigation_app/resources/views/widget_view.dart';
import 'package:navigation_app/screens/login_screen/widgets/auth_dialog.dart';

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
    print('reg');
    setState(() {
      _authVisible = true;
      _selectedTab = SelectedTab.Register;
    });
  }

  void _login() {
    print('login');
    setState(() {
      _authVisible = true;
      _selectedTab = SelectedTab.Login;
    });
  }

  void _onAuthClose() {
    print('yeee');
    setState(() {
      _authVisible = false;
    });
  }
}

class _LoginView extends WidgetView<Login, _LoginController> {
  _LoginView(_LoginController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
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
                Image.asset('assets/splash_logo.png'),
                const SizedBox(height: kToolbarHeight),
                const Text(
                  'Správce tras',
                  style: TextStyle(fontSize: 54),
                ),
                Text(
                  'Mějte své trasy u sebe',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                const SizedBox(height: 40.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.black),
                          child: Text('Mám účet'),
                          onPressed: state._login,
                        ),
                      ),
                      const SizedBox(width: 10.0),
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
