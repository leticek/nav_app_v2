import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../resources/providers.dart';

class StartNavigationButton extends StatelessWidget {
  final double offset;
  final void Function() onTap;

  const StartNavigationButton({Key key, this.offset, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final isLoading = watch(watchConnectionProvider).transferInProgress;
        return AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          right: 1.2.h,
          bottom: offset,
          child: isLoading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                )
              : Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.play_arrow_sharp),
                    color: Colors.white,
                    onPressed: onTap,
                  ),
                ),
        );
      },
    );
  }
}
