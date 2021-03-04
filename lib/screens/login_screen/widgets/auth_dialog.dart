import 'package:flutter/material.dart';
import 'package:navigation_app/screens/login_screen/login_screen.dart';
import '../../../resources/views/widget_view.dart';

class AuthDialog extends StatefulWidget {
  final SelectedTab _selectedTab;
  final Function _onClose;

  const AuthDialog({SelectedTab selectedTab, Function onClose})
      : _selectedTab = selectedTab,
        _onClose = onClose;

  @override
  _AuthDialogController createState() => _AuthDialogController();
}

class _AuthDialogController extends State<AuthDialog> {
  @override
  Widget build(BuildContext context) => _AuthDialogView(this);
}

class _AuthDialogView extends WidgetView<AuthDialog, _AuthDialogController> {
  _AuthDialogView(_AuthDialogController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Column(
        children: [
          Center(child: Text('Mrdko')),
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.clear),
            onPressed: state.widget._onClose
          ),],
      ),
    );
  }
}
