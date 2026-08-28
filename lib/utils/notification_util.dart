import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationUtil {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSetting = InitializationSettings(android: androidSetting);
    await _plugin.initialize(initSetting);
  }

  static Future<void> scheduleNotify({
    required int id,
    required String title,
    required String body,
    required DateTime targetTime,
  }) async {
    final tz.TZDateTime tzTime = tz.TZDateTime.from(targetTime, tz.local);
    const androidDetail = AndroidNotificationDetails(
      "food_timer_channel",
      "食材保鲜提醒",
      channelDescription: "食材到期提醒通知",
      importance: Importance.high,
      priority: Priority.high,
    );
    const notifyDetail = NotificationDetails(android: androidDetail);
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzTime,
      notifyDetail,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelNotify(int id) async {
    await _plugin.cancel(id);
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}