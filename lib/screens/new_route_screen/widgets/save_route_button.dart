import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SaveRouteButton extends StatelessWidget {
  const SaveRouteButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black),
        child: IconButton(
          icon: Icon(
            Icons.check_circle_outline_sharp,
            color: Colors.white,
            size: 25.0.sp,
          ),
          onPressed: () {},
        ),
      ),
      bottom: 1.2.h,
      right: 1.2.h,
    );
  }
}
