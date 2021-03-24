import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'file:///C:/Users/smiea/IdeaProjects/nav_app_v2/lib/resources/utils/validator.dart';

import 'file:///C:/Users/smiea/IdeaProjects/nav_app_v2/lib/resources/enums.dart';
import 'file:///C:/Users/smiea/IdeaProjects/nav_app_v2/lib/resources/providers.dart';

import '../../../resources/widget_view.dart';

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
    _confirmPasswordField.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    FocusManager.instance.primaryFocus.unfocus();
    if (_formKey.currentState.validate()) {
      if (!await context
          .read(authServiceProvider)
          .signUp(_email.text, _password.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.read(authServiceProvider).errorCode),
          ),
        );
      }
    }
  }
}

class _RegisterFormView
    extends WidgetView<RegisterForm, _RegisterFormController> {
  const _RegisterFormView(_RegisterFormController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      final user = watch(authServiceProvider);
      return Form(
        key: state._formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Container(
              padding: const EdgeInsets.all(0),
              child: TextFormField(
                key: const Key("email-field"),
                controller: state._email,
                validator: (value) => Validator.validateEmail(value),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
                style: const TextStyle(fontSize: 20),
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
                key: const Key("password-field"),
                controller: state._password,
                obscureText: true,
                validator: (value) =>
                    Validator.validatePasswordComplexity(value),
                decoration: const InputDecoration(
                  labelText: 'Heslo',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
                style: const TextStyle(fontSize: 20),
                onEditingComplete: () => FocusScope.of(context)
                    .requestFocus(state._confirmPasswordField),
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.all(0),
              child: TextFormField(
                focusNode: state._confirmPasswordField,
                key: const Key("confirm_password-field"),
                controller: state._confirmPassword,
                obscureText: true,
                validator: (value) =>
                    Validator.comparePasswords(state._password.text, value),
                decoration: const InputDecoration(
                  labelText: 'Potvrďte heslo',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
                style: const TextStyle(fontSize: 20),
                onEditingComplete: state._signup,
              ),
            ),
            const SizedBox(height: 10.0),
            if (user.status == AuthStatus.authenticating)
              const Center(child: CircularProgressIndicator()),
            if (user.status != AuthStatus.authenticating)
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.black),
                  onPressed: state._signup,
                  child: const Text('Registrovat'),
                ),
              ),
          ],
        ),
      );
    });
  }
}
