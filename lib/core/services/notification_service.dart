import 'package:subscription_manage/core/exported_files/exported_file.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import '../models/subscription_model.dart';
import 'storage_services/subscription_storage_service.dart';

class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  static const String _channelId = 'subscription_reminder_channel';

  static Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    try {
      final String tzName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(tzName));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (response) {},
    );

    _initialized = true;
  }

  static int _idFromSubscriptionId(String id) => id.hashCode & 0x7FFFFFFF;

  static Future<void> cancelForSubscription(String id) async {
    await _plugin.cancel(_idFromSubscriptionId(id));
  }

  static Future<void> scheduleForSubscription(
    SubscriptionModel subscription,
    int daysBefore,
    int hour,
    int minute,
  ) async {
    await initialize();

    // compute next due date based on cycle
    DateTime next = _nextDueDate(subscription);

    final scheduledDate = DateTime(
      next.year,
      next.month,
      next.day,
      hour,
      minute,
    ).subtract(Duration(days: daysBefore));

    final now = DateTime.now();
    if (scheduledDate.isBefore(now)) {
      // if this occurrence already passed, try next cycle
      next = _advanceByCycle(next, subscription.paymentCycle);
    }

    final target = DateTime(
      next.year,
      next.month,
      next.day,
      hour,
      minute,
    ).subtract(Duration(days: daysBefore));

    if (target.isBefore(now)) return;

    final tz.TZDateTime tzDate = tz.TZDateTime.from(target, tz.local);

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      'Subscription Reminders',
      channelDescription: 'Reminders before subscription due date',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.zonedSchedule(
      _idFromSubscriptionId(subscription.id),
      '${subscription.subscriptionName} ${'is_due'.tr}',
      'Your subscription will expire soon',
      tzDate,
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      payload: 'subscription:${subscription.id}',
    );
  }

  static DateTime _nextDueDate(SubscriptionModel s) {
    final DateTime start = s.startDate;
    final DateTime now = DateTime.now();

    DateTime candidate = start;
    while (!candidate.isAfter(now)) {
      candidate = _advanceByCycle(candidate, s.paymentCycle);
    }

    return candidate;
  }

  static DateTime _advanceByCycle(DateTime date, String cycle) {
    switch (cycle.toLowerCase()) {
      case 'weekly':
        return date.add(const Duration(days: 7));
      case 'yearly':
        return DateTime(date.year + 1, date.month, date.day);
      case 'monthly':
      default:
        return DateTime(date.year, date.month + 1, date.day);
    }
  }

  static Future<void> rescheduleAll() async {
    await initialize();
    final SubscriptionStorageService storage = SubscriptionStorageService.instance;
    final STService st = STService();

    final bool? enabled = st.getBool('reminder_enabled');
    if (enabled != true) {
      // cancel all existing subscription notifications
      final subs = await storage.readSubscriptions();
      for (final s in subs) {
        await cancelForSubscription(s.id);
      }
      return;
    }

    final String? cadence = st.getData('reminder_cadence');
    final String? hourStr = st.getData('reminder_hour');
    final String? minuteStr = st.getData('reminder_minute');
    final String? period = st.getData('reminder_period');

    final int hour = int.tryParse(hourStr ?? '10') ?? 10;
    final int minute = int.tryParse(minuteStr ?? '10') ?? 10;
    int hour24 = hour;
    if (period != null && period.toLowerCase() == 'pm' && hour != 12) {
      hour24 = hour + 12;
    }

    final int daysBefore;
    switch ((cadence ?? '1 day').toLowerCase()) {
      case 'today':
        daysBefore = 0;
        break;
      case '1 day':
        daysBefore = 1;
        break;
      case '3 day':
        daysBefore = 3;
        break;
      case '1 week':
        daysBefore = 7;
        break;
      default:
        daysBefore = 1;
    }

    final subs = await storage.readSubscriptions();
    for (final s in subs) {
      await cancelForSubscription(s.id);
      await scheduleForSubscription(s, daysBefore, hour24, minute);
    }
  }
}
