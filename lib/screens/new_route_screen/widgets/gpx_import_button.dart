import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GpxImportButton extends StatelessWidget {
  const GpxImportButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 1.2.h,
      left: 1.2.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.black),
        onPressed: () => debugPrint('ola'),
        child: const Text('GPX'),
      ),
    );
  }
}
