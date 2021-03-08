import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigation_app/resources/providers.dart';
import 'package:sizer/sizer.dart';

class SaveRouteButton extends StatelessWidget {
  const SaveRouteButton({Function onTap}) : _onTap = onTap;

  final Function _onTap;

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
                    Icons.check,
                    color: Colors.white,
                    size: 25.0.sp,
                  ),
                  onPressed: _onTap,
                ),
              )
            : CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
        bottom: 1.2.h,
        right: 1.2.h,
      );
    });
  }
}
