import 'package:flutter/material.dart';
import 'package:navigation_app/resources/models/saved_route.dart';
import 'package:navigation_app/screens/my_routes_screen/widgets/delete_dialog.dart';
import 'package:navigation_app/screens/my_routes_screen/widgets/route_preview.dart';
import 'package:sizer/sizer.dart';

class RouteWidget extends StatelessWidget {
  RouteWidget(this.savedRoute);

  final SavedRoute savedRoute;

  final textStyle = TextStyle(
    fontSize: 9.0.sp,
    fontWeight: FontWeight.w600,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(key: UniqueKey(),
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.cyan,
          ),
          margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          height: 31.0.h,
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
            onPressed: () {},
            child: const Text('Upravit'),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
                primary: Colors.black, backgroundColor: Colors.white),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => DeleteConfirmation(savedRoute),
            ),
            child: const Text('Smazat'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.black),
            onPressed: () {},
            child: const Text('Navigovat'),
          )
        ],
      ),
    );
  }

  Positioned buildAscentDescent() {
    return Positioned(
      left: 74.5.w,
      bottom: 8.0.h,
      right: 5.0.w,
      child: SizedBox(
        height: 6.0.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.arrow_circle_up),
                Text(savedRoute.ascent.toString(),
                    overflow: TextOverflow.ellipsis, style: textStyle),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.arrow_circle_down),
                Text(savedRoute.descent.toString(),
                    overflow: TextOverflow.ellipsis, style: textStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Positioned buildStartAndGoal() {
    return Positioned(
      left: 5.0.w,
      bottom: 8.0.h,
      right: 27.0.w,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        height: 6.5.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.person_pin),
                Text(savedRoute.start.name,
                    overflow: TextOverflow.ellipsis, style: textStyle),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.flag_rounded),
                Text(savedRoute.goal.name,
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
      left: 5.0.w,
      top: 1.7.h,
      right: 5.0.w,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1.5),
        ),
        height: 16.0.h,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: RoutePreview(savedRoute)),
      ),
    );
  }
}
