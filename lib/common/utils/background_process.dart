import 'dart:ui';
import 'dart:isolate';
import 'package:pickeat/api_service/api_service.dart';
import 'package:pickeat/common/utils/notification_helper.dart';


import '../../main.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;
  static String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  static Future<void> callback() async {
    print('Alarm fired!');
    final NotificationHelper _notificationHelper = NotificationHelper();
    var result = await ApiService().restaurantList();

    await _notificationHelper.showNotification(flutterLocalNotificationsPlugin, result);
    print("fetch background service");
    print(result.restaurants.map((e) => e.name));
    print("executed at");
    print(DateTime.now());

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}
