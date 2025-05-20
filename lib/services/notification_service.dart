// lib/services/notification_service.dart
//
// Сервис-обёртка над flutter_local_notifications.
// • init                — инициализация плагина + запрос разрешений.
// • scheduleHourly      — планирует повтор каждый час (используется в приложении).
// • scheduleTestMinute  — пример «каждую минуту» (ОТЛАДКА, закомментирован).
// • cancelAll           — отменяет все активные напоминания.

import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  // ---------- синглтон ----------
  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  // Плагин для работы с нативными уведомлениями
  final FlutterLocalNotificationsPlugin _flutter =
      FlutterLocalNotificationsPlugin();

  // ---------- инициализация ----------
  Future<void> init() async {
    // 1) Подключаем базу тайм-зон (нужно для zonedSchedule)
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.local);

    // 2) Базовые настройки (иконка, callback-и)
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinInit = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidInit,
      iOS: darwinInit,
      macOS: darwinInit,
    );
    await _flutter.initialize(settings);

    // 3) Запрашиваем системные разрешения
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

  // ---------- общие детали канала ----------
  static const _androidDetails = AndroidNotificationDetails(
    'reminder_channel',                          // ID канала
    'Напоминания',                               // Название
    channelDescription: 'Регулярные напоминания «Пора заниматься»',
    importance: Importance.defaultImportance,
    priority: Priority.defaultPriority,
  );
  static const _details = NotificationDetails(android: _androidDetails);

  // ------------------------------------------------------------------
  //   ОСНОВНОЙ СПОСОБ — ЕЖЕЧАСНОЕ НАПОМИНАНИЕ
  // ------------------------------------------------------------------
  Future<void> scheduleHourly() async {
    await _flutter.periodicallyShow(
      0,                        // постоянный ID
      'Пора заниматься',        // заголовок
      'Не забудьте решить пару задач!', // текст
      RepeatInterval.hourly,    // ⏰ КАЖДЫЙ ЧАС
      _details,
      androidScheduleMode: AndroidScheduleMode.inexact,
    );
  }

  // ------------------------------------------------------------------
  //   ВАРИАНТ ДЛЯ ОТЛАДКИ — КАЖДУЮ МИНУТУ
  //   ❗ По умолчанию ЗАКОММЕНТИРОВАН, т.к. быстро разряжает батарею.
  // ------------------------------------------------------------------
  /*
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

  // ---------- отмена ----------
  Future<void> cancelAll() async {
    await _flutter.cancel(0); // удаляем уведомление с ID 0
  }
}
