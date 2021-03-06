import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigation_app/resources/providers.dart';
import 'package:sizer/sizer.dart';

class SearchHints extends StatelessWidget {
  const SearchHints({onTap}) : _onTap = onTap;

  final Function _onTap;

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
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3)),
                      ],
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(15)),
                  width: 90.0.w,
                  height: 25.0.h,
                  child: ListView.builder(
                    itemCount: _service.suggestions.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(_service.suggestions[index].label,
                          style: TextStyle(color: Colors.white)),
                      subtitle: Text(
                        '${_service.suggestions[index].latLng.latitude}  ${_service.suggestions[index].latLng.longitude}',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () => _onTap(_service.suggestions[index]),
                    ),
                  )),
            )
          : Container();
    });
  }
}
