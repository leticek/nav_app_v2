import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigation_app/resources/providers.dart';
import 'package:sizer/sizer.dart';

class SaveRouteButton extends StatelessWidget {
  const SaveRouteButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final isLoading = watch(openRouteServiceProvider).isLoading;
      return Positioned(
        child: !isLoading
            ? Container(
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.black),
                child: IconButton(
                  icon: Icon(
                    Icons.check_circle_outline_sharp,
                    color: Colors.white,
                    size: 25.0.sp,
                  ),
                  onPressed: () {},
                ),
              )
            : CircularProgressIndicator(),
        bottom: 1.2.h,
        right: 1.2.h,
      );
    });
  }
}
