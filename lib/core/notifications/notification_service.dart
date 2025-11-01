import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();
  // keep channel id aligned with Firebase meta-data in AndroidManifest.xml
  static const _channelId = 'default_channel_fcm';
  static const _channelName = 'General';
  static const _channelDesc = 'Canal de notificaciones generales';
  Future<void> init() async {
    const androidInit = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(android: androidInit, iOS: iosInit);
    await _local.initialize(settings);
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.high,
      playSound: true,
    );
    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> showLocal({required String title, required String body}) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    await _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }

  /// Descarga una imagen remota y muestra una notificación Big Picture en Android.
  /// Si la descarga falla, hace fallback a `showLocal`.
  Future<void> showBigPictureFromUrl({
    required String title,
    required String body,
    required String imageUrl,
  }) async {
    try {
      final uri = Uri.parse(imageUrl);
      final resp = await http.get(uri).timeout(const Duration(seconds: 10));
      if (resp.statusCode == 200) {
        final bytes = resp.bodyBytes;
        final tmp = Directory.systemTemp;
        final file = File('${tmp.path}/bigpic_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await file.writeAsBytes(bytes);
        await showBigPicture(title: title, body: body, imagePath: file.path);
        return;
      } else {
        // fallback
        // ignore: avoid_print
        print('NotificationService: failed to download image, status=${resp.statusCode}');
      }
    } catch (e, st) {
      // ignore: avoid_print
      print('NotificationService: error downloading image -> $e');
      // ignore: avoid_print
      print(st);
    }

    // fallback to simple notification
    await showLocal(title: title, body: body);
  }

  /// Muestra notificación con imagen local (Big Picture)
  Future<void> showBigPicture({
    required String title,
    required String body,
    required String imagePath, // ruta local al archivo de imagen
  }) async {
    final bigPicture = BigPictureStyleInformation(
      FilePathAndroidBitmap(imagePath), // archivo local
      contentTitle: title,
      summaryText: body,
      hideExpandedLargeIcon: false,
    );
    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      styleInformation: bigPicture,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    await _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }
}