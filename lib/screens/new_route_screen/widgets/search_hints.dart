import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigation_app/resources/models/named_point.dart';
import 'package:navigation_app/resources/providers.dart';
import 'package:sizer/sizer.dart';

class SearchHints extends StatelessWidget {
  const SearchHints({Future<void> Function(NamedPoint) onTap}) : _onTap = onTap;

  final Future<void> Function(NamedPoint) _onTap;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      final _suggestions = watch(openRouteServiceProvider).suggestions;
      return _suggestions.isNotEmpty
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
                            offset: const Offset(0, 3)),
                      ],
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(15)),
                  width: 90.0.w,
                  height: 25.0.h,
                  child: ListView.builder(
                    itemCount: _suggestions.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(_suggestions[index].name as String,
                          style: const TextStyle(color: Colors.white)),
                      subtitle: Text(
                        '${_suggestions[index].point.latitude}  ${_suggestions[index].point.longitude}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      onTap: () => _onTap(_suggestions[index] as NamedPoint),
                    ),
                  )),
            )
          : Container();
    });
  }
}
