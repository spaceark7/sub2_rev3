import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:pickeat/common/navigation.dart';
import 'package:pickeat/common/utils/background_process.dart';
import 'package:pickeat/common/utils/notification_helper.dart';
import 'package:pickeat/controller/database_controller.dart';
import 'package:pickeat/controller/preferences_controller.dart';
import 'package:pickeat/controller/scheduling_controller.dart';
import 'package:pickeat/data/database/database_helper.dart';
import 'package:pickeat/ui/detail_restaurant_screen.dart';
import 'package:pickeat/ui/favorite_screen.dart';
import 'package:pickeat/ui/home_screen.dart';
import 'package:pickeat/ui/onBoarding/onboarding_screens.dart';
import 'package:pickeat/ui/profile_screen.dart';
import 'package:pickeat/ui/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controller/restaurant_controller.dart';
import 'data/model/restaurant.dart';
import 'data/preferences/preferences_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();
  _service.initializeIsolate();
  if (Platform.isAndroid) {
    print("executed android");
    await AndroidAlarmManager.initialize();
  }
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final RestaurantController restaurantController = Get.put(RestaurantController());
  final DatabaseController databaseController = Get.put(DatabaseController(databaseHelper: DatabaseHelper()));
  final SchedulingController schedulingController = Get.put(SchedulingController());
  final PreferencesController preferencesController = Get.put(PreferencesController(preferencesHelper: PreferencesHelper(sharedPreferences: SharedPreferences.getInstance())));
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PreferencesController>(
      builder: (preferences) {
        return GetMaterialApp(
          navigatorKey: navigatorKey,
          title: 'PickEat',
          debugShowCheckedModeBanner: false,
          theme: preferences.themeData,
          builder: (context, child) {
            return CupertinoTheme(
                data: CupertinoThemeData(brightness: preferences.isDarkTheme.value ? Brightness.dark : Brightness.light),
                child: Material(
                  child: child,
                ));
          },
          initialRoute: preferences.isFirstLaunch.value ? OnBoardingScreen.routeName : HomeScreen.routeName,
          routes: {
            HomeScreen.routeName: (context) => HomeScreen(),
            DetailScreen.routeName: (context) => DetailScreen(restaurant: ModalRoute.of(context)?.settings.arguments as Restaurant),
            FavoriteScreen.routeName: (context) => FavoriteScreen(),
            ProfileScreen.routeName: (context) => ProfileScreen(),
            SettingsScreen.routeName: (context) => SettingsScreen(),
            OnBoardingScreen.routeName: (context) => OnBoardingScreen(),
          },
        );
      },
    );
  }
}
