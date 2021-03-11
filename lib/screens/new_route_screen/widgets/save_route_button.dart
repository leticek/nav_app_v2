import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigation_app/resources/providers.dart';
import 'package:sizer/sizer.dart';

class SaveRouteButton extends StatelessWidget {
  const SaveRouteButton({void Function() onTap}) : _onTap = onTap;

  final void Function() _onTap;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final isLoading = watch(openRouteServiceProvider).isLoading;
      return Positioned(
        right: 1.2.h,
        bottom: 1.2.h,
        child: !isLoading
            ? Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.black),
                child: IconButton(
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 25.0.sp,
                  ),
                  onPressed: _onTap,
                ),
              )
            : const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
      );
    });
  }
}
