import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pickeat/common/utils/notification_helper.dart';
import 'package:pickeat/controller/restaurant_controller.dart';
import 'package:pickeat/ui/detail_restaurant_screen.dart';
import 'package:pickeat/ui/favorite_screen.dart';
import 'package:pickeat/ui/profile_screen.dart';
import 'package:pickeat/ui/restaurant_list_screen.dart';
import 'package:pickeat/widgets/platformWidget.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationHelper _notificationHelper = NotificationHelper();
  int _bottomNavIndex = 0;
  RestaurantController state = Get.find();
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _notificationHelper.configureSelectNotificationSubject(DetailScreen.routeName);
    initConnectivity();

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
     selectNotificationSubject.close();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    state.fetchAllRestaurant();
    setState(() {
      _connectionStatus = result;
    });
  }

  List<Widget> _listWidget = [
    RestaurantListScreen(),
    FavoriteScreen(),
    ProfileScreen(),
  ];

  List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(icon: Icon(Platform.isIOS ? CupertinoIcons.house : Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Platform.isIOS ? CupertinoIcons.heart : Icons.favorite), label: 'Favorite'),
    BottomNavigationBarItem(icon: Icon(Platform.isIOS ? CupertinoIcons.person : Icons.person), label: 'Profile'),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  /// Android View Widgets

  Widget _buildAndroid(BuildContext context) {
    if (_connectionStatus == ConnectivityResult.none) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/NO_CONNECTION.png',
                height: 350,
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _bottomNavIndex,
          items: _bottomNavBarItems,
        ),
      );
    } else {
      return Scaffold(
        body: _listWidget[_bottomNavIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _bottomNavIndex,
          items: _bottomNavBarItems,
          onTap: _onBottomNavTapped,
        ),
      );
    }
  }

  /// IOS View Widgets

  Widget _buildIOS(BuildContext context) {
    if (_connectionStatus == ConnectivityResult.none) {
      return CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            items: _bottomNavBarItems,
          ),
          tabBuilder: (context, index) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/NO_CONNECTION.png',
                    height: 350,
                  )
                ],
              ),
            );
          });
    } else {
      return CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            items: _bottomNavBarItems,
          ),
          tabBuilder: (context, index) {
            return _listWidget[index];
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIOS);
  }
}
