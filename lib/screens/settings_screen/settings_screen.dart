import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigation_app/resources/providers.dart';
import 'package:navigation_app/resources/widget_view.dart';
import 'package:navigation_app/screens/settings_screen/widgets/map_style_choice.dart';
import 'package:sizer/sizer.dart';

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
          Positioned(
            top: 9.0.h,
            child: Container(
              margin: const EdgeInsets.only(left: 5, right: 5),
              height: 35.0.h,
              width: 97.5.w,
              child: DefaultTabController(
                initialIndex:
                    context.read(authServiceProvider).userModel.mapStyle,
                length: 3,
                child: RotatedBox(
                  quarterTurns: 1,
                  child: TabBar(
                    onTap: (index) => context
                        .read(firestoreProvider)
                        .updateMapStyle(index,
                            context.read(authServiceProvider).userModel.userId),
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.cyan,
                    ),
                    tabs: [
                      MapStyleChoice(
                        title: "Klasická",
                        options: TileLayerOptions(
                          urlTemplate:
                              "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: ['a', 'b', 'c'],
                        ),
                      ),
                      MapStyleChoice(
                        title: "Turistická",
                        options: TileLayerOptions(
                          urlTemplate:
                              "https://tiles.wmflabs.org/hikebike/{z}/{x}/{y}.png",
                        ),
                      ),
                      MapStyleChoice(
                        title: "Topo",
                        options: TileLayerOptions(
                          urlTemplate:
                              "https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png",
                          subdomains: ['a', 'b', 'c'],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 48.0.h,
            left: 5.0.w,
            child: Text(
              "Profil trasy",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0.sp),
            ),
          ),
          Positioned(
            top: 54.0.h,
            child: Container(
              //color: Colors.yellow,
              margin: const EdgeInsets.all(8),
              height: 20.0.h,
              width: 97.5.w,
              child: DefaultTabController(
                initialIndex:
                    context.read(authServiceProvider).userModel.mapStyle,
                length: 3,
                child: RotatedBox(
                  quarterTurns: 1,
                  child: TabBar(
                    onTap: (index) => null,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.cyan,
                    ),
                    tabs: [
                      RotatedBox(
                        quarterTurns: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Icon(Icons.directions_bike),
                            Text(
                              'Trasa bude optimalizovaná pro jízdu na kole.',
                            ),
                          ],
                        ),
                      ),
                      RotatedBox(
                        quarterTurns: 3,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [
                              //Icon(),
                              Text(
                                  'Trasa bude optimalizovaná pro jízdu na kole.'),
                            ]),
                      ),
                      RotatedBox(
                        quarterTurns: 3,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [
                              Icon(Icons.directions_bike),
                              Text(
                                  'Trasa bude optimalizovaná pro jízdu na kole.'),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
