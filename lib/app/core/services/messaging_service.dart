import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../analytics/analytics_manager.dart';

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  // if (message == null) return;
  developer.log(message.notification.toString());
  final pre = await SharedPreferences.getInstance();
  pre.setBool("isNotiCalled", true);
}

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage2(NotificationResponse message) async {
  // if (message == null) return;
  final pre = await SharedPreferences.getInstance();
  pre.setBool("isNotiCalled", true);
}

class MessagingService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    "high_importance_channel",
    "Ai Là Triệu Phú",
    description: "this channel is used for important notification",
    importance: Importance.max,
  );

  final _localNoti = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    final fCMToken = await _firebaseMessaging.getToken();
    developer.log(fCMToken.toString());
    initPushNotification();
    initLocalNotification();
  }

  Future<void> initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(
      (value) {
        if (value != null) handleBackgroundMessage(value);
      },
    );
    FirebaseMessaging.onMessageOpenedApp.listen(handleBackgroundMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final noti = message.notification;
      if (noti == null) return;
      _localNoti.show(
        noti.hashCode,
        noti.title,
        noti.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: "@mipmap/ic_launcher",
            priority: Priority.high,
            importance: Importance.max,
            styleInformation: const BigTextStyleInformation(''),
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
      // showDailyMessage();
    });
  }

  void scheduleMessage() {
    try {
      final isScheduleMessage =
          FirebaseRemoteConfig.instance.getBool("isScheduleMessage");
      if (!isScheduleMessage) return;
      String messageNoti =
          FirebaseRemoteConfig.instance.getString("messageNoti");
      List<String> message = messageNoti.split(';');
      const String timeZoneName = 'Asia/Ho_Chi_Minh';
      final tz.Location timeZone = tz.getLocation(timeZoneName);
      DateTime scheduledDate = DateTime.now().add(const Duration(hours: 1));
      tz.TZDateTime tzDateTime = tz.TZDateTime.from(scheduledDate, timeZone);
      _localNoti.zonedSchedule(
        14092002,
        null,
        message[Random().nextInt(message.length)],
        tzDateTime,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: "@mipmap/ic_launcher",
            priority: Priority.high,
            importance: Importance.max,
            styleInformation: const BigTextStyleInformation(''),
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: jsonEncode(message),
      );
    } catch (e) {
      AnalyticsManager.sendAnalyticsEvent(
          e.toString().replaceAll(RegExp(r'[^a-zA-Z]'), '_'));
      return;
    }
  }

  void showDailyMessage() {
    String messageNoti = FirebaseRemoteConfig.instance.getString("messageNoti");
    List<String> message = messageNoti.split(';');
    _localNoti.periodicallyShow(
      13022005,
      null,
      message[Random().nextInt(message.length)],
      RepeatInterval.daily,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          icon: "@mipmap/ic_launcher",
          priority: Priority.high,
          importance: Importance.max,
          styleInformation: const BigTextStyleInformation(''),
        ),
      ),
    );
  }

  Future<void> initLocalNotification() async {
    const ios = DarwinInitializationSettings();
    const android = AndroidInitializationSettings("@mipmap/ic_launcher");
    const setting = InitializationSettings(
      android: android,
      iOS: ios,
    );
    await _localNoti.initialize(
      setting,
      onDidReceiveBackgroundNotificationResponse: handleBackgroundMessage2,
      onDidReceiveNotificationResponse: handleBackgroundMessage2,
    );

    final platform = _localNoti.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }
}
