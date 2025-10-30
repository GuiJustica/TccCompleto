import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tcc/constants/CoresDefinidas/roxo_tres.dart';
import 'package:intl/intl.dart';

class Registros extends StatefulWidget {
  const Registros({super.key});

  @override
  State<Registros> createState() => _RegistrosState();
}

class _RegistrosState extends State<Registros> {
  final _database = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> eventos = [];
  String deviceId = '';
  bool carregado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!carregado) {
      final args = ModalRoute.of(context)!.settings.arguments as String;
      deviceId = args;
      _loadEventos();
      _removeOldEventos();
      carregado = true;
    }
  }

  // === FUNÇÃO PARA MAPEAR INTENSIDADE ===
  String mapIntensidade(double conf) {
    if (conf >= 0.7) return "Alta";
    if (conf >= 0.4) return "Média";
    return "Baixa";
  }

  // === FUNÇÃO PARA FORMATAR HORA ===
  String _formatHoraLocal(String ts) {
    if (ts.isEmpty) return '';
    try {
      // Remove microsegundos extras se existirem
      String cleaned = ts.split('.').first;
      // Adiciona 'Z' para indicar UTC
      final dt = DateTime.parse('${cleaned}Z').toLocal();
      return DateFormat('dd/MM HH:mm').format(dt);
    } catch (e) {
      return '';
    }
  }

  // === REMOVER EVENTOS ANTIGOS ===
  void _removeOldEventos() async {
    final now = DateTime.now(); // horário local
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshotEventos =
        await FirebaseDatabase.instance
            .ref('usuarios/${user.uid}/eventos_sons')
            .get();

    if (!snapshotEventos.exists) return;

    for (var raspberry in snapshotEventos.children) {
      for (var evento in raspberry.children) {
        final data = evento.value as Map<dynamic, dynamic>?;
        if (data == null) continue;

        final tsString = data["timestamp"]?.toString();
        if (tsString == null) continue;

        try {
          // Limpa microsegundos extras e adiciona Z para UTC
          String cleaned = tsString.split('.').first;
          final ts = DateTime.parse('${cleaned}Z').toLocal();

          final diffTime = now.difference(ts).inDays;

          debugPrint('Timestamp do evento (local): $ts');
          debugPrint('Diferença de Dias: $diffTime');

          // Remove se tiver mais de 3 dias
          if (diffTime >= 1) {
            final path =
                'usuarios/${user.uid}/eventos_sons/${raspberry.key}/${evento.key}';
            await FirebaseDatabase.instance.ref(path).remove();
            debugPrint('✅ Evento removido: $path');
          }
        } catch (e) {
          debugPrint('❌ Erro ao parsear timestamp: $tsString | $e');
        }
      }
    }
  }

  // === CARREGA EVENTOS PARA EXIBIÇÃO ===
  void _loadEventos() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshotEventos =
        await _database
            .child('usuarios/${user.uid}/eventos_sons/$deviceId')
            .get();

    final snapshotDispositivo =
        await _database
            .child('usuarios/${user.uid}/dispositivos/$deviceId')
            .get();

    String local = 'Desconhecido';
    if (snapshotDispositivo.exists) {
      final data = snapshotDispositivo.value as Map<dynamic, dynamic>?;
      local = data?['ambiente']?.toString() ?? 'Desconhecido';
    }

    List<Map<String, dynamic>> listaEventos = [];

    if (snapshotEventos.exists) {
      for (var evento in snapshotEventos.children) {
        final data = evento.value as Map<dynamic, dynamic>;
        final conf = (data['confidence'] ?? 0).toDouble();
        final timestamp = data['timestamp']?.toString() ?? '';

        // Parse seguro para UTC -> converte para local
        String cleaned = timestamp.split('.').first;
        final tsLocal = DateTime.parse('${cleaned}Z').toLocal();
        final horaFormatada = DateFormat('dd/MM HH:mm').format(tsLocal);

        listaEventos.add({
          "idEvento": evento.key,
          "raspberry": deviceId,
          "som": data["label"]?.toString() ?? "N/A",
          "intensidade": mapIntensidade(conf),
          "local": local,
          "hora": horaFormatada,
          "timestamp": tsLocal,
        });
      }
    }

    listaEventos.sort((a, b) {
      final t1 = a["timestamp"] as DateTime?;
      final t2 = b["timestamp"] as DateTime?;
      if (t1 == null || t2 == null) return 0;
      return t2.compareTo(t1);
    });

    setState(() {
      eventos = listaEventos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: fundoRoxoTres,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Guilo's Sound",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  'home',
                  (route) => false,
                );
              },
              child: Image.asset('assets/images/logobranco.png', height: 35),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: eventos.length,
        itemBuilder: (context, index) {
          final e = eventos[index];

          // Mapeia intensidade para cor
          Color intensidadeColor;
          switch (e["intensidade"]) {
            case "Alta":
              intensidadeColor = Colors.red;
              break;
            case "Média":
              intensidadeColor = Colors.orange;
              break;
            default:
              intensidadeColor = Colors.green;
          }

          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e["som"],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.trending_up,
                              color: intensidadeColor,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Intensidade: ${e["intensidade"]}",
                              style: TextStyle(color: intensidadeColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 18),
                            const SizedBox(width: 6),
                            Text("Local: ${e["local"]}"),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 18),
                            const SizedBox(width: 6),
                            Text("Horário: ${e["hora"]}"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Botão de remoção
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user == null) return;

                      final path =
                          'usuarios/${user.uid}/eventos_sons/${e["raspberry"]}/${e["idEvento"]}';
                      debugPrint('🔴 Removendo evento em: $path');
                      await FirebaseDatabase.instance.ref(path).remove();

                      setState(() {
                        eventos.removeAt(index);
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Registro removido')),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
