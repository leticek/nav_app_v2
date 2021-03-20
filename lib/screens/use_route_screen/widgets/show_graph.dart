import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ShowGraphButton extends StatelessWidget {
  final double offset;
  final void Function() onTap;

  const ShowGraphButton({Key key, this.onTap, this.offset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 1.2.h,
      bottom: offset,
      child: Container(
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
        child: IconButton(
          icon: const Icon(Icons.poll),
          color: Colors.white,
          onPressed: onTap,
        ),
      ),
    );
  }
}
