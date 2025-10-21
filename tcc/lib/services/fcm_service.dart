import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class FcmService {
  static final _database = FirebaseDatabase.instance.ref();
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Inicializa notificações locais e listeners do Realtime Database
  static Future<void> initialize() async {
    debugPrint('🚀 Inicializando FcmService...');

    // Inicializa notificações locais
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

    // Pega UID do usuário autenticado
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint('⚠️ Nenhum usuário logado. FcmService não será inicializado.');
      return;
    }
    final userId = user.uid;
    debugPrint('UID atual: $userId');

    // Caminho para os eventos_sons do usuário
    final userEventsRef = _database.child('usuarios/$userId/eventos_sons');

    // Listener para cada nova Raspberry vinculada
    userEventsRef.onChildAdded.listen((DatabaseEvent raspberrySnapshot) {
      final raspberryId = raspberrySnapshot.snapshot.key;
      if (raspberryId == null) {
        debugPrint('⚠️ Raspberry sem ID detectada');
        return;
      }
      debugPrint('👂 Escutando eventos da Raspberry: $raspberryId');

      // Listener para cada novo evento dessa Raspberry
      userEventsRef.child(raspberryId).onChildAdded.listen((
        DatabaseEvent eventSnapshot,
      ) {
        final data = eventSnapshot.snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          final title = data['label']?.toString() ?? 'Novo som detectado';
          final body =
              'Confiança: ${data['confidence']?.toString() ?? 'N/A'}\nHorário: ${data['timestamp'] ?? ''}';
          debugPrint('📡 Novo evento detectado em $raspberryId: $data');
          _showNotification(title, body);
        } else {
          debugPrint('⚠️ Evento vazio detectado em $raspberryId');
        }
      });
    });
  }

  /// Mostra notificação local no celular
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
      DateTime.now().millisecondsSinceEpoch ~/ 1000, // id único
      title,
      body,
      details,
    );
  }
}
