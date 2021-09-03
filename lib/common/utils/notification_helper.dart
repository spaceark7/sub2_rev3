import 'dart:convert';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pickeat/data/model/restaurant.dart';

import 'package:rxdart/rxdart.dart';

import '../navigation.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;
  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid = AndroidInitializationSettings('launcher_icon');
    var initializationSettingsIOS = IOSInitializationSettings(requestAlertPermission: false, requestBadgePermission: false, requestSoundPermission: false);

    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String? payload) async {
      if (payload != null) {
        print('Notification Payload: ' + payload);
      }
      selectNotificationSubject.add(payload ?? 'empty payload');
    });
  }

  Future<void> showNotification(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin, RestaurantResult restaurants) async {
    var _channelId = "1";
    var _channelName = "channel_01";
    var _channelDescription = "Pick\'eat Notification";

    var androidPlatformChannelSpesifics = AndroidNotificationDetails(_channelId, _channelName, _channelDescription,
        importance: Importance.max, priority: Priority.high, ticker: 'ticker', styleInformation: DefaultStyleInformation(true, true));

    var iosPlatformChannelSpesifics = IOSNotificationDetails();
    var platformChannelSpesifics = NotificationDetails(android: androidPlatformChannelSpesifics, iOS: iosPlatformChannelSpesifics);

    var titleNotification = "<b>Today Recommendations</b>";

    Random random = new Random();
    int index = restaurants.restaurants.length - 1;
    int seedIndex = random.nextInt(index - 0);
    var titleNews = restaurants.restaurants[seedIndex].name;
    var payloadData = restaurants.restaurants[seedIndex];

    await flutterLocalNotificationsPlugin.show(0, titleNotification, titleNews, platformChannelSpesifics, payload: json.encode(payloadData.toJson()));
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen((String payload) async {
      var restaurant = Restaurant.fromJson(json.decode(payload));
      print('from configure helper');
      // print(data.restaurants.map((e) => e.name));
      // var restaurant = data.restaurants[0];
      Navigation.intentWithData(route, restaurant);
    });
  }

  void requestIOSPermissions(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}
