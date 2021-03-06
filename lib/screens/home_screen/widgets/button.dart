import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomeScreenButton extends StatelessWidget {
  final String _label;
  final String _heroTag;
  final IconData _icon;
  final Function _onTap;

  HomeScreenButton({label, heroTag, icon, onTap})
      : _label = label,
        _heroTag = heroTag,
        _icon = icon,
        _onTap = onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTap,
      child: Container(
        margin: EdgeInsets.all(5),
        width: SizerUtil.orientation == Orientation.portrait ? 45.0.w : 40.0.h,
        height: SizerUtil.orientation == Orientation.portrait ? 40.0.h : 45.0.w,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.cyan,
            borderRadius: BorderRadius.circular(35)),
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            children: [
              SizedBox(
                height: constraints.maxHeight / 14,
              ),
              Hero(
                tag: _heroTag,
                child: Icon(
                  _icon,
                  size: constraints.maxHeight / 2,
                ),
              ),
              SizedBox(
                height: constraints.maxHeight / 6,
              ),
              Text(
                _label,
                style: TextStyle(fontSize: 17.0.sp),
              )
            ],
          ),
        ),
      ),
    );
  }
}
