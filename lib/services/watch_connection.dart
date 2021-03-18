import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WatchService with ChangeNotifier {
  String watchStatus = "-";
  MethodChannel _methodChannel;
  EventChannel _eventChannel;
  static const String _methodChannelName = 'commChannel';
  static const String _eventChannelName = 'eventChannel';
  List<String> availableDevices = [];

  WatchService() {
    _methodChannel = const MethodChannel(_methodChannelName);
    _methodChannel.invokeMethod('initSDK');
    _eventChannel = const EventChannel(_eventChannelName);
    _eventChannel.receiveBroadcastStream().listen(responseStream);
  }

  void responseStream(dynamic event) {
    final Map<String, dynamic> response = Map.from(event as Map);
    switch (response['response'] as int) {
      case 1:
        watchStatus = 'Připojte hodinky';
        break;
      case 2:
        watchStatus = 'Chyba připojení k hodinkám';
        break;
      case 3:
        availableDevices = List.from(response['payload'] as List);
        break;
      case 4:
        watchStatus = response['payload'] as String;
        break;
      default:
        watchStatus = '-';
        break;
    }
    notifyListeners();
  }

  void searchForAvailableDevices() => _methodChannel.invokeMethod('getDevices');
}
