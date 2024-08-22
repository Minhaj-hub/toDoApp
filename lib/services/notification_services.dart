import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationServices {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleReminder(String title, String dec, String priority,
      String date, String time) async {
    List<String> dateParts = date.split('/');
    String dateTime = time.substring(0, 5);
    List<String> timeParts = dateTime.split(':');

    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);

    int hour = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);
    tz.initializeTimeZones();

    var scheduledTime = DateTime(year, month, day, hour, minutes);
    final finalDate = scheduledTime.subtract(const Duration(minutes: 1));

    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      'Task Reminder',
      'Get ready, only one more hour for $title.',
      tz.TZDateTime.from(finalDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails('task id', 'task name',
            channelDescription: 'task description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
