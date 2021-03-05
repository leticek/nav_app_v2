import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigation_app/resources/providers/providers.dart';
import 'package:navigation_app/services/auth.dart';
import '../../../resources/views/widget_view.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormController createState() => _RegisterFormController();
}

class _RegisterFormController extends State<RegisterForm> {
  @override
  Widget build(BuildContext context) => _RegisterFormView(this);

  TextEditingController _email;
  TextEditingController _password;
  TextEditingController _confirmPassword;
  FocusNode _passwordField;
  FocusNode _confirmPasswordField;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
    _confirmPassword = TextEditingController(text: "");
    _passwordField = FocusNode();
    _confirmPasswordField = FocusNode();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  _signup() async {
    if (_formKey.currentState.validate()) {
      await context
          .read(authServiceProvider)
          .signup(_email.text, _password.text);
    }
  }
}

class _RegisterFormView
    extends WidgetView<RegisterForm, _RegisterFormController> {
  _RegisterFormView(_RegisterFormController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      final user = watch(authServiceProvider);
      return Form(key: state._formKey,
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
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(state._passwordField),
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
                onEditingComplete: () => FocusScope.of(context)
                    .requestFocus(state._confirmPasswordField),
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.all(0),
              child: TextFormField(
                focusNode: state._confirmPasswordField,
                key: Key("confirm_password-field"),
                controller: state._confirmPassword,
                obscureText: true,
                validator: (value) => (value.isEmpty) ? 'Chyba' : null,
                decoration: InputDecoration(
                  labelText: 'Potvrďte heslo',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.cyan),
                  ),
                ),
                style: TextStyle(fontSize: 20),
                onEditingComplete: state._signup,
              ),
            ),
            SizedBox(height: 10.0),
            if (user.status == Status.Authenticating)
              Center(child: CircularProgressIndicator()),
            if (user.status != Status.Authenticating)
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.black),
                  onPressed: state._signup,
                  child: Text('Registrovat'),
                ),
              ),
          ],
        ),
      );
    });
  }
}
