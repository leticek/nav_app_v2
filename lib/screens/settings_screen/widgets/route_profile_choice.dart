import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RouteProfileStyle extends StatelessWidget {
  final IconData icon;
  final String label;

  const RouteProfileStyle({
    Key key,
    this.icon,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 3,
      child: Row(
        children: [
          SizedBox(
            width: 25.0.w,
          ),
          Icon(icon),
          SizedBox(
            width: 5.0.w,
          ),
          Text(label),
        ],
      ),
    );
  }
}
