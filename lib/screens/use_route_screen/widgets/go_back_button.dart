import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GoBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 1.2.h,
      top: 1.2.h,
      child: Container(
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
        child: BackButton(color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
