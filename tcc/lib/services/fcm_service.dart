import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // <-- importante para formatar data

class FcmService {
  static final _database = FirebaseDatabase.instance.ref();
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    debugPrint('🚀 Inicializando FcmService...');

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _notificationsPlugin.initialize(initSettings);
    debugPrint('✅ Notificações locais inicializadas');

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final userId = user.uid;

    final userEventsRef = _database.child('usuarios/$userId/eventos_sons');

    userEventsRef.onChildAdded.listen((DatabaseEvent raspberrySnapshot) {
      final raspberryId = raspberrySnapshot.snapshot.key;
      if (raspberryId == null) return;

      userEventsRef.child(raspberryId).onChildAdded.listen((
        DatabaseEvent eventSnapshot,
      ) {
        final data = eventSnapshot.snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          // Formata intensidade
          final intensity = _mapIntensidade(
            (data['confidence'] ?? 0).toDouble(),
          );

          // Formata hora
          final hora = _formatHora(data['timestamp'] ?? '');

          final title = data['label']?.toString() ?? 'Novo som detectado';
          final body = 'Intensidade: $intensity\nHorário: $hora';
          _showNotification(title, body);
        }
      });
    });
  }

  static String _mapIntensidade(double conf) {
    if (conf >= 0.7) return 'Alta';
    if (conf >= 0.4) return 'Média';
    return 'Baixa';
  }

  static String _formatHora(String ts) {
    if (ts.isEmpty) return '';
    try {
      final dt = DateTime.parse(ts);
      return DateFormat('dd/MM HH:mm').format(dt);
    } catch (e) {
      return '';
    }
  }

  static Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'channel_id',
          'Eventos',
          channelDescription: 'Notificações de novos sons detectados',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }
}
