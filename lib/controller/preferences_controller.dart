import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickeat/common/style.dart';
import 'package:pickeat/data/preferences/preferences_helper.dart';

class PreferencesController extends GetxController {
  PreferencesHelper preferencesHelper;
  PreferencesController({required this.preferencesHelper}) {
    _getDailyReminderPrefs();
    _getTheme();
    _getFirstLaunch();
  }

  var isDarkTheme = false.obs;
  var isDailyActive = false.obs;
  var isFirstLaunch = true.obs;

  ThemeData get themeData => isDarkTheme.value ? darkTheme : lightTheme;

  void _getTheme() async {
    isDarkTheme.value = await preferencesHelper.isDarkTheme;
    update();
  }

  void _getDailyReminderPrefs() async {
    isDailyActive.value = await preferencesHelper.isDailyReminderActive;
    update();
  }

  void _getFirstLaunch() async {
    isFirstLaunch.value = await preferencesHelper.isFirstLaunch;
    update();
  }

  void enableDarkTheme(bool value) {
    preferencesHelper.setDarkTheme(value);
    _getTheme();
    update();
  }

  void enableDailyPrefs(bool value) {
    preferencesHelper.setDailyReminder(value);
    _getDailyReminderPrefs();
    update();
  }

  void disableFirstLaunch() {
    preferencesHelper.setFirstLaunch(false);
    _getFirstLaunch();
    update();
  }
}
