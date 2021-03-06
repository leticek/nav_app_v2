import 'package:flutter/material.dart';

import './login.dart';
import './register.dart';
import '../../../resources/enums.dart';
import '../../../resources/widget_view.dart';

class AuthDialog extends StatefulWidget {
  final SelectedTab _selectedTab;
  final void Function() _onClose;

  const AuthDialog({SelectedTab selectedTab, void Function() onClose})
      : _selectedTab = selectedTab,
        _onClose = onClose;

  @override
  _AuthDialogController createState() => _AuthDialogController();
}

class _AuthDialogController extends State<AuthDialog> {
  @override
  Widget build(BuildContext context) => _AuthDialogView(this);

  int _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget._selectedTab.index;
  }

  void _onTap(int index) {
    setState(() {
      _selectedTab = index;
    });
  }
}

class _AuthDialogView extends WidgetView<AuthDialog, _AuthDialogController> {
  const _AuthDialogView(_AuthDialogController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DefaultTabController(
        initialIndex: state.widget._selectedTab.index,
        length: 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TabBar(
                    onTap: (index) => state._onTap(index),
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.white,
                    tabs: const <Widget>[
                      Tab(
                        text: "Přihlásit se",
                      ),
                      Tab(
                        text: "Registrovat se",
                      )
                    ],
                  ),
                ),
                IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.clear),
                  onPressed: state.widget._onClose,
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey.shade200,
              ),
              padding: const EdgeInsets.all(0),
              height: 300,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: state._selectedTab == 0 ? LoginForm() : RegisterForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
