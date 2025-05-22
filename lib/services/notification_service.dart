// lib/services/notification_service.dart

import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  /// Конструктор singleton
  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();
  /// Экземпляр сервиса
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _flutter =
      FlutterLocalNotificationsPlugin();

  /// Инициализирует плагин и запрашивает разрешения
  Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.local);

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinInit = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidInit,
      iOS: darwinInit,
      macOS: darwinInit,
    );
    await _flutter.initialize(settings);

    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      if (!status.isGranted) await Permission.notification.request();
    }
    if (Platform.isIOS) {
      await _flutter
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
    if (Platform.isMacOS) {
      await _flutter
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  /// Настройки Android-канала уведомлений
  static const _androidDetails = AndroidNotificationDetails(
    'reminder_channel',
    'Напоминания',
    channelDescription: 'Регулярные напоминания «Пора заниматься»',
    importance: Importance.defaultImportance,
    priority: Priority.defaultPriority,
  );
  static const _details = NotificationDetails(android: _androidDetails);

  /// Планирует уведомление каждый час
  Future<void> scheduleHourly() async {
    await _flutter.periodicallyShow(
      0,
      'Пора заниматься',
      'Не забудьте решить пару задач!',
      RepeatInterval.hourly,
      _details,
      androidScheduleMode: AndroidScheduleMode.inexact,
    );
  }

  /*
  /// Планирует уведомление каждую минуту (отладка)
  Future<void> scheduleTestMinute() async {
    await _flutter.periodicallyShow(
      0,
      'Тест: пора заниматься',
      'Не забудьте решить пару задач!',
      RepeatInterval.everyMinute,
      _details,
      androidScheduleMode: AndroidScheduleMode.inexact,
    );
  }
  */

  /// Отменяет все уведомления
  Future<void> cancelAll() async {
    await _flutter.cancel(0);
  }
}
