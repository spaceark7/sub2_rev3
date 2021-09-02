import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:get/get.dart';
import 'package:pickeat/common/utils/background_process.dart';
import 'package:pickeat/common/utils/date_time_helper.dart';


class SchedulingController extends GetxController {
  var isScheduled = false.obs;

  Future<bool> scheduleReminder(bool value) async {
    isScheduled.value = value;
    update();
    if (isScheduled.value) {
      print('Scheduling Reminder Activated');

      final DateTime schedHours = DateTimeHelper.format();
      print(schedHours);
     
      return await AndroidAlarmManager.periodic(
        Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: schedHours,
        exact: true,
        wakeup: true,
      );
    } else {
      print('Scheduling Reminders Canceled');
      update();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
