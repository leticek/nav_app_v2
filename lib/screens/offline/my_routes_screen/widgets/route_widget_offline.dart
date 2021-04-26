import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import './delete_dialog_offline.dart';
import './route_preview_offline.dart';
import '../../../../resources/models/saved_route.dart';
import '../../../../resources/utils/route_builder.dart';

class RouteWidgetOffline extends StatefulWidget {
  const RouteWidgetOffline(this.savedRoute, UniqueKey key) : super(key: key);

  final SavedRoute savedRoute;

  @override
  _RouteWidgetOfflineState createState() => _RouteWidgetOfflineState();
}

class _RouteWidgetOfflineState extends State<RouteWidgetOffline> {
  final textStyle = TextStyle(
    fontSize: 11.0.sp,
    fontWeight: FontWeight.w600,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
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
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return DeleteConfirmationOffline(widget.savedRoute);
                },
              );
            },
            child: const Text('Smazat'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.black),
            onPressed: () => Navigator.pushNamed(
                context, AppRoutes.useRouteOffline,
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
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1.5),
        ),
        height: 19.0.h,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: RoutePreviewOffline(widget.savedRoute)),
      ),
    );
  }
}
