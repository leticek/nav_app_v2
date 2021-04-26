import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sizer/sizer.dart';

import './widgets/choice_picker.dart';
import './widgets/delete_account.dart';
import './widgets/map_style_choice.dart';
import './widgets/route_profile_choice.dart';
import '../../resources/providers.dart';
import '../../resources/widget_view.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenController createState() => _SettingsScreenController();
}

class _SettingsScreenController extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) => _SettingsScreenView(this);

  final List<Widget> _mapStylesList = [
    MapStyleChoice(
      title: "Klasická",
      options: TileLayerOptions(
        urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
        subdomains: ['a', 'b', 'c'],
      ),
    ),
    MapStyleChoice(
      title: "Turistická",
      options: TileLayerOptions(
        urlTemplate: "https://tiles.wmflabs.org/hikebike/{z}/{x}/{y}.png",
      ),
    ),
    MapStyleChoice(
      title: "Topo",
      options: TileLayerOptions(
        urlTemplate: "https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png",
        subdomains: ['a', 'b', 'c'],
      ),
    )
  ];

  final List<Widget> _routeProfileList = const [
    RouteProfileStyle(
      icon: MdiIcons.walk,
      label: 'Chůze',
    ),
    RouteProfileStyle(
      icon: MdiIcons.hiking,
      label: 'Chůze po horách',
    ),
    RouteProfileStyle(
      icon: Icons.directions_bike,
      label: 'Cyklistika',
    ),
    RouteProfileStyle(
      icon: MdiIcons.imageFilterHdr,
      label: 'Horská cyklistika',
    ),
  ];

  void updateMapStyle(int index) =>
      context.read(firestoreProvider).updateMapStyle(
          index, context.read(authServiceProvider).userModel.userId);

  void updateRouteProfile(int index) =>
      context.read(firestoreProvider).updateRouteProfile(
          index, context.read(authServiceProvider).userModel.userId);
}

class _SettingsScreenView
    extends WidgetView<SettingsScreen, _SettingsScreenController> {
  const _SettingsScreenView(_SettingsScreenController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan,
        title: Hero(
          tag: 'settings',
          child: Icon(
            Icons.settings_outlined,
            color: Colors.black,
            size: 30.0.sp,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 2.0.h,
            left: 5.0.w,
            child: Text(
              "Vzhled mapy",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0.sp),
            ),
          ),
          ChoicePicker(
            initialIndex: context.read(authServiceProvider).userModel.mapStyle,
            length: 3,
            onTap: state.updateMapStyle,
            tabs: state._mapStylesList,
            top: 9.0.h,
            height: 33.0.h,
          ),
          Positioned(
            top: 44.0.h,
            left: 5.0.w,
            child: Text(
              "Profil trasy",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0.sp),
            ),
          ),
          ChoicePicker(
            initialIndex:
                context.read(authServiceProvider).userModel.routeProfileId,
            length: 4,
            onTap: state.updateRouteProfile,
            tabs: state._routeProfileList,
            top: 51.0.h,
            height: 27.0.h,
          ),
          Positioned(
            width: 99.5.w,
            top: 43.0.h,
            child: const Divider(
              height: 4,
              thickness: 1,
              indent: 5,
              endIndent: 5,
              color: Colors.black,
            ),
          ),
          Positioned(
            width: 99.5.w,
            top: 78.7.h,
            child: const Divider(
              height: 4,
              thickness: 1,
              indent: 5,
              endIndent: 5,
              color: Colors.black,
            ),
          ),
          Positioned(
            width: 99.5.w,
            height: 10.0.h,
            top: 79.5.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => const DeleteAccountConfirmation(),
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.black),
                  child: const Text('Smazat účet'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
