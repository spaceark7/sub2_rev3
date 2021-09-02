import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickeat/controller/preferences_controller.dart';
import 'package:pickeat/controller/scheduling_controller.dart';
import 'package:pickeat/widgets/custom_dialog.dart';
import 'package:pickeat/widgets/platformWidget.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = '/settings_page';
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIOS);
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Settings",
            style: TextStyle(fontSize: 32),
          ),
          toolbarHeight: 80,
        ),
        body: _buildList(context)
        // SafeArea(
        //   child: AnimatedList(
        //       key: _listKey,
        //       initialItemCount: _listItem.length ,
        //       itemBuilder: (context, index, animation) {

        //         return _listItem.isEmpty ? Center(child: Text('No Data'),) :

        //         SlideTransition(position: animation.drive(_offset),
        //         child: CardRestaurant(restaurant: _listItem[index ]));
        //       }),
        // ),
        );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: Text('Your Favorite Places', style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black))),
        child: _buildList(context)
        //   SafeArea(
        //   child: AnimatedList(
        //       key: _listKey,
        //       initialItemCount: _listItem.length ,
        //       itemBuilder: (context, index, animation) {

        //         return _listItem.isEmpty ? Center(child: Text('No Data'),) :

        //         SlideTransition(position: animation.drive(_offset), child: FavCardRestaurant(restaurant: _listItem[index ]));
        //       }),
        // ),

        );
  }
}

Widget _buildList(BuildContext context) {
  return GetBuilder<PreferencesController>(
    builder: (preferences) {
      return ListView(
        children: [
          Material(
            child: ListTile(
              title: Text(
                'Dark Theme',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              trailing: Switch.adaptive(
                  value: preferences.isDarkTheme.value,
                  onChanged: (value) {
                    preferences.enableDarkTheme(value);
                  }),
            ),
          ),
          Material(
            child: GetBuilder<SchedulingController>(
              builder: (scheduled) {
                return ListTile(
                  title: Text(
                    'Reminders',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  trailing: Switch.adaptive(
                      value: preferences.isDailyActive.value,
                      onChanged: (value) async {
                        if (Platform.isIOS) {
                          customDialog(context);
                        } else {
                          scheduled.scheduleReminder(value);
                          preferences.enableDailyPrefs(value);
                        }
                      }),
                );
              },
            ),
          ),
        ],
      );
    },
  );
}
