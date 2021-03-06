import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigation_app/resources/providers.dart';
import 'package:sizer/sizer.dart';

class SearchHints extends StatelessWidget {
  const SearchHints({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      final _service = watch(openRouteServiceProvider);
      print(_service.suggestions.length);
      return _service.suggestions.isNotEmpty
          ? Positioned(
              left: 5.0.w,
              bottom: 4.0.h,
              child: Container(
                  width: 90.0.w,
                  height: 25.0.h,
                  color: Colors.cyan,
                  child: ListView.builder(
                    itemCount: _service.suggestions.length,
                    itemBuilder: (context, index) =>
                        Text(_service.suggestions[index].label),
                  )),
            )
          : Container();
    });
  }
}
