import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences;
  static const DARK_THEME = 'DARK_THEME';
  static const DAILY_REMINDER = 'DAILY_REMINDER';
  static const FIRST_LAUNCH = 'FIRST_LAUNCH';
  static const USER_LOGIN = 'USER_LOGIN';


  PreferencesHelper({required this.sharedPreferences});

  Future<bool> get isDarkTheme async {
    final prefs = await sharedPreferences;
    return prefs.getBool(DARK_THEME) ?? false;
  }

  void setDarkTheme(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(DARK_THEME, value);
  }

  Future<bool> get isDailyReminderActive async {
    final prefs = await sharedPreferences;
    return prefs.getBool(DAILY_REMINDER) ?? false;
  }

  void setDailyReminder(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(DAILY_REMINDER, value);
  }

  Future<bool> get isFirstLaunch async {
    final prefs = await sharedPreferences;
    return prefs.getBool(FIRST_LAUNCH) ?? true;
  }

  void setFirstLaunch(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(FIRST_LAUNCH, value);
  }

  Future<bool> get isLogin async {
    final prefs = await sharedPreferences;
    return prefs.getBool(USER_LOGIN) ?? false;
  }

  void setUserLogin(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(USER_LOGIN, value);
  }
}
