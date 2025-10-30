import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FcmService {
  static final _database = FirebaseDatabase.instance.ref();
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'channel_id';
  static const String _channelName = 'Eventos';
  static const String _channelDescription =
      'Notificações de novos sons detectados';

  static Future<void> initialize() async {
    debugPrint('🚀 Inicializando FcmService...');

    // Configura Android e iOS
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

    // Usuário logado?
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final userId = user.uid;

    final userEventsRef = _database.child('usuarios/$userId/eventos_sons');

    // Escuta todos os dispositivos do usuário
    userEventsRef.onChildAdded.listen((DatabaseEvent deviceSnapshot) {
      final raspberryId = deviceSnapshot.snapshot.key; // ID da Raspberry Pi
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

          final x = calcularTempoResposta(data['timestamp']);
          // Formata hora
          final hora = _formatHora(data['timestamp'] ?? '');

          final title = data['label']?.toString() ?? 'Novo som detectado';
          final body = 'Intensidade: $intensity\nHorário: $hora';
          _showNotification(title, body);
        }
      });
    });
  }

  static calcularTempoResposta(String timestampEvento) {
    try {
      // Interpreta o timestamp como UTC
      final eventoTime = DateTime.parse(timestampEvento).toUtc();

      // Aplica o fuso horário manual (-3 horas)
      final eventoLocal = eventoTime.subtract(Duration(hours: 3));

      final agora = DateTime.now();
      final diff = agora.difference(eventoLocal).inMilliseconds;

      final diffSegundos = diff / 1000.0;
      debugPrint("🕒 Tempo total de resposta: $diffSegundos segundos");
      return diffSegundos;
    } catch (e) {
      debugPrint("Erro ao calcular tempo de resposta: $e\n$timestampEvento");
      return 0.0;
    }
  }

  static String _mapIntensidade(double conf) {
    if (conf >= 0.9) return 'Alta';
    if (conf >= 0.6) return 'Média';
    return 'Baixa';
  }

  static String _formatHora(String ts) {
    if (ts.isEmpty) return '';
    try {
      final cleaned = ts.split('.').first;
      final dt = DateTime.parse('${cleaned}Z').toLocal();
      return DateFormat('dd/MM HH:mm').format(dt);
    } catch (e) {
      return '';
    }
  }

  static Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
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
