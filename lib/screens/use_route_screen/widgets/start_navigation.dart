import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class StartNavigationButton extends StatelessWidget {
  final double offset;

  const StartNavigationButton({Key key, this.offset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      right: 1.2.h,
      bottom: offset,
      child: Container(
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
        child: IconButton(
          icon: const Icon(Icons.play_arrow_sharp),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
