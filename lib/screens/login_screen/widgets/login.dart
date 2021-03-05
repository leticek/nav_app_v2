import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigation_app/resources/providers/providers.dart';
import 'package:navigation_app/services/auth.dart';
import '../../../resources/views/widget_view.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormController createState() => _LoginFormController();
}

class _LoginFormController extends State<LoginForm> {
  @override
  Widget build(BuildContext context) => _LoginFormView(this);

  TextEditingController _email;
  TextEditingController _password;
  FocusNode _passwordField;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
    _passwordField = FocusNode();
  }

  _login() async {
    if (_formKey.currentState.validate()) {
      await context
          .read(authServiceProvider)
          .signIn(_email.text, _password.text);
    }
  }
}

class _LoginFormView extends WidgetView<LoginForm, _LoginFormController> {
  _LoginFormView(_LoginFormController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      final user = watch(authServiceProvider);
      return Form(
        key: state._formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            Container(
              padding: const EdgeInsets.all(0),
              child: TextFormField(
                key: Key("email-field"),
                controller: state._email,
                validator: (value) => (value.isEmpty) ? 'Chyba' : null,
                decoration: InputDecoration(
                  labelText: 'Email',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.cyan),
                  ),
                ),
                style: TextStyle(fontSize: 20),
                textInputAction: TextInputAction.next,
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(state._passwordField);
                },
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.all(0),
              child: TextFormField(
                focusNode: state._passwordField,
                key: Key("password-field"),
                controller: state._password,
                obscureText: true,
                validator: (value) => (value.isEmpty) ? 'Chyba' : null,
                decoration: InputDecoration(
                  labelText: 'Heslo',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.cyan),
                  ),
                ),
                style: TextStyle(fontSize: 20),
                onEditingComplete: state._login,
              ),
            ),
            SizedBox(height: 10.0),
            if (user.status == Status.Authenticating)
              Center(child: CircularProgressIndicator()),
            if (user.status != Status.Authenticating)
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.black),
                  onPressed: state._login,
                  child: Text('Přihlásit se'),
                ),
              ),
          ],
        ),
      );
    });
  }
}
