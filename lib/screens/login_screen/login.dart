import 'package:flutter/material.dart';
import 'package:navigation_app/resources/views/widget_view.dart';


class Login extends StatefulWidget {
  @override
  _LoginController createState() => _LoginController();
   final String _text = 'ahoj';

}
 
class _LoginController extends State<Login> {
  @override
  Widget build(BuildContext context) => _LoginView(this);
}
 
class _LoginView extends WidgetView<Login, _LoginController> {
  _LoginView(_LoginController state) : super(state);
 
  @override
  Widget build(BuildContext context) {
    return Container(child: Text(state.widget._text),);
  }
}