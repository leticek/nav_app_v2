import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigation_app/resources/providers.dart';
import 'package:navigation_app/resources/widget_view.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenController createState() => _SettingsScreenController();
}

class _SettingsScreenController extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) => _SettingsScreenView(this);
}

class _SettingsScreenView
    extends WidgetView<SettingsScreen, _SettingsScreenController> {
  const _SettingsScreenView(_SettingsScreenController state) : super(state);

  @override
  Widget build(BuildContext context) {
    //TODO: vylepšit UI a UX, fix herp widget
    return Scaffold(
      appBar: AppBar(),
      body: Consumer(
        builder: (context, watch, child) {
          final watchService = watch(watchConnectionProvider);

          return watchService.availableDevices.isEmpty
              ? ElevatedButton(
                  onPressed: () => context.read(watchConnectionProvider).searchForAvailableDevices(),
                  child: const Text('Najít zařízení'),
                )
              : ListView.builder(
                  itemBuilder: (context, index) => ListTile(
                    title: Text(
                      watchService.availableDevices.elementAt(index),
                    ),
                  ),
                  itemCount: watchService.availableDevices.length,
                );
        },
      ),
    );
  }
}
