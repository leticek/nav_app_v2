import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ChoicePicker extends StatelessWidget {
  const ChoicePicker({
    Key key,
    this.initialIndex,
    this.length,
    this.onTap,
    this.tabs,
    this.top,
    this.height,
  }) : super(key: key);

  final int initialIndex;
  final int length;
  final void Function(int) onTap;
  final List<Widget> tabs;
  final double top;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      child: Container(
        margin: const EdgeInsets.only(left: 5, right: 5),
        height: height,
        width: 97.5.w,
        child: DefaultTabController(
          initialIndex: initialIndex,
          length: length,
          child: RotatedBox(
            quarterTurns: 1,
            child: TabBar(
                onTap: onTap,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.cyan,
                ),
                tabs: tabs),
          ),
        ),
      ),
    );
  }
}
