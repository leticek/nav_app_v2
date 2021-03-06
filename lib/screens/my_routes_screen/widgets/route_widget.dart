import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:sizer/sizer.dart';

import './delete_dialog.dart';
import './route_preview.dart';
import '../../../resources/models/saved_route.dart';
import '../../../resources/utils/route_builder.dart';

class RouteWidget extends StatefulWidget {
  const RouteWidget(this.savedRoute);

  final SavedRoute savedRoute;

  @override
  _RouteWidgetState createState() => _RouteWidgetState();
}

class _RouteWidgetState extends State<RouteWidget> {
  final textStyle = TextStyle(
    fontSize: 11.0.sp,
    fontWeight: FontWeight.w600,
  );

  Future _saveRoute() async {
    final db = Localstore.instance;
    await db
        .collection('routes')
        .doc(widget.savedRoute.id)
        .set(widget.savedRoute.toLocalstoreMap());
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Trasa byla uložena do zařízení.'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: UniqueKey(),
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.cyan,
          ),
          margin: const EdgeInsets.all(5),
          height: 39.0.h,
        ),
        buildMap(),
        buildStartAndGoal(),
        buildAscentDescent(),
        buildButtons(context)
      ],
    );
  }

  Positioned buildButtons(BuildContext context) {
    return Positioned(
      left: 5.0.w,
      right: 5.0.w,
      bottom: 1.1.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
                primary: Colors.black, backgroundColor: Colors.white),
            onPressed: () async {
              await Navigator.pushNamed(context, AppRoutes.editRoute,
                  arguments: widget.savedRoute);
            },
            child: const Text('Upravit'),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
                primary: Colors.black, backgroundColor: Colors.white),
            onPressed: _saveRoute,
            child: const Text('Uložit'),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
                primary: Colors.black, backgroundColor: Colors.white),
            onPressed: () => showDialog(
              context: context,
              builder: (context) {
                return DeleteConfirmation(widget.savedRoute);
              },
            ),
            child: const Text('Smazat'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.black),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.useRoute,
                arguments: widget.savedRoute),
            child: const Text('Navigovat'),
          )
        ],
      ),
    );
  }

  Positioned buildAscentDescent() {
    return Positioned(
      left: 3.2.w,
      bottom: 5.6.h,
      right: 3.2.w,
      child: SizedBox(
        height: 7.0.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.arrow_circle_up),
            Text('${widget.savedRoute.ascent.toString()}m ',
                overflow: TextOverflow.ellipsis, style: textStyle),
            SizedBox(width: 3.5.w),
            const Icon(Icons.arrow_circle_down),
            Text('${widget.savedRoute.descent.toString()}m',
                overflow: TextOverflow.ellipsis, style: textStyle),
            SizedBox(width: 3.5.w),
            const Icon(Icons.swap_calls),
            Text('${widget.savedRoute.length.toString()}km',
                overflow: TextOverflow.ellipsis, style: textStyle)
          ],
        ),
      ),
    );
  }

  Positioned buildStartAndGoal() {
    return Positioned(
      left: 3.2.w,
      bottom: 9.6.h,
      right: 3.2.w,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        height: 10.0.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_pin),
                SizedBox(width: 5.0.w),
                Text(widget.savedRoute.start.name,
                    overflow: TextOverflow.ellipsis, style: textStyle),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.flag_rounded),
                SizedBox(width: 5.0.w),
                Text(widget.savedRoute.goal.name,
                    overflow: TextOverflow.ellipsis, style: textStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Positioned buildMap() {
    return Positioned(
      left: 3.2.w,
      top: 1.7.h,
      right: 3.2.w,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1.5),
        ),
        height: 19.0.h,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: RoutePreview(widget.savedRoute)),
      ),
    );
  }
}
