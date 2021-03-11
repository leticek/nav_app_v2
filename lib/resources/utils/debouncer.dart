import 'dart:async';

class Debouncer {
  final Duration delay;
  Timer _timer;

  Debouncer({this.delay = const Duration(milliseconds: 400)});

  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }
}
