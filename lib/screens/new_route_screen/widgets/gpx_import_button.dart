import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GpxImportButton extends StatelessWidget {
  const GpxImportButton({
    Key key,
    this.onPressed,
  }) : super(key: key);

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 1.2.h,
      left: 1.2.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.black),
        onPressed: onPressed,
        child: const Text('GPX'),
      ),
    );
  }
}
