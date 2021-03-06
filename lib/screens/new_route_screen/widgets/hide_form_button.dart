import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HideFormButton extends StatelessWidget {
  const HideFormButton({
    Function onTap,
  }) : _onTap = onTap;

  final Function _onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.cyan),
      child: IconButton(
        icon: Icon(
          Icons.arrow_circle_up,
          size: 25.0.sp,
        ),
        onPressed: _onTap,
      ),
    );
  }
}
