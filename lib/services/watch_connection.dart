import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WatchService with ChangeNotifier {
  String watchStatus = '';
  String appStartStatus = '';
  MethodChannel _methodChannel;
  EventChannel _eventChannel;
  EventChannel _messageChannel;
  static const String _methodChannelName = 'commChannel';
  static const String _eventChannelName = 'eventChannel';
  static const String _messageChannelName = 'messageChannel';
  List<String> availableDevices = [];
  Map<String, dynamic> routeSteps;
  Map<String, dynamic> routePoints;
  Map<String, dynamic> boundingBox;
  bool transferInProgress = false;

  WatchService() {
    _methodChannel = const MethodChannel(_methodChannelName);
    _eventChannel = const EventChannel(_eventChannelName);
    _methodChannel.invokeMethod('initSDK');
    _eventChannel.receiveBroadcastStream().listen(eventChannelStream);
  }

  void startMessageChannel() {
    _messageChannel = const EventChannel(_messageChannelName);
    _messageChannel.receiveBroadcastStream().listen(messageChannelStream);
    _methodChannel.invokeMethod('receiveMessages');
  }

  void eventChannelStream(dynamic event) {
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
      case 5:
        _handleAppStartup(response['payload'] as String);
        break;
      default:
        watchStatus = '-';
        break;
    }
    notifyListeners();
  }

  Future<void> _handleAppStartup(String message) async {
    appStartStatus = message;
    notifyListeners();
    for (var i = 0; i < 3; i++) {
      await Future.delayed(const Duration(seconds: 1), () {
        appStartStatus =
            appStartStatus.padRight(appStartStatus.length + 1, '.');
        notifyListeners();
      });
    }
    appStartStatus = '';
    notifyListeners();
  }

  void searchForAvailableDevices() => _methodChannel.invokeMethod('getDevices');

  Future<void> openApp() => _methodChannel.invokeMethod('openApp');

  Future<void> _sendMessage(dynamic data) async {
    _methodChannel.invokeMethod('sendMessage', data);
  }

  Future<void> sendRoute({
    @required Map<String, dynamic> routeSteps,
    @required Map<String, dynamic> routePoints,
    @required Map<String, dynamic> boundingBox,
  }) async {
    transferInProgress = true;
    notifyListeners();
    this.routeSteps = routeSteps;
    this.routePoints = routePoints;
    this.boundingBox = boundingBox;
    _sendMessage(this.routeSteps);
  }

  void messageChannelStream(dynamic event) {
    if (event['type'] == 0 && event['status'] == 1) {
      _sendMessage(routePoints);
    } else if (event['type'] == 1 && event['status'] == 1) {
      _sendMessage(boundingBox);
    } else if (event['type'] == 2 && event['status'] == 1) {
      transferInProgress = false;
      notifyListeners();
    }
  }
}
