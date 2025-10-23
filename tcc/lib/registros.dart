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

  @override
  void initState() {
    super.initState();
    _loadEventos();
  }

  // === FUNÇÃO PARA MAPEAR INTENSIDADE ===
  String mapIntensidade(double conf) {
    if (conf >= 0.7) return "Alta";
    if (conf >= 0.4) return "Média";
    return "Baixa";
  }

  // === FUNÇÃO PARA FORMATAR HORA ===
  String formatHora(String ts) {
    if (ts.isEmpty) return "";
    try {
      // Parseia a string ISO 8601 para DateTime
      final dt = DateTime.parse(ts);
      // Formata para "dd/MM HH:mm"
      return DateFormat('dd/MM HH:mm').format(dt);
    } catch (e) {
      return "";
    }
  }

  void _loadEventos() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshotEventos =
        await _database.child('usuarios/${user.uid}/eventos_sons').get();
    final snapshotDispositivos =
        await _database.child('usuarios/${user.uid}/dispositivos').get();

    Map<String, String> raspberryToLocal = {};
    if (snapshotDispositivos.exists) {
      for (var device in snapshotDispositivos.children) {
        final data = device.value as Map<dynamic, dynamic>?;
        raspberryToLocal[device.key ?? ""] =
            data?['ambiente']?.toString() ?? "Desconhecido";
      }
    }

    List<Map<String, dynamic>> listaEventos = [];

    if (snapshotEventos.exists) {
      for (var raspberry in snapshotEventos.children) {
        final local = raspberryToLocal[raspberry.key ?? ""] ?? "Desconhecido";

        for (var evento in raspberry.children) {
          final data = evento.value as Map<dynamic, dynamic>;
          final conf = (data["confidence"] ?? 0).toDouble();
          final timestamp = data["timestamp"];
          listaEventos.add({
            "idEvento": evento.key,
            "raspberry": raspberry.key,
            "som": data["label"]?.toString() ?? "N/A",
            "intensidade": mapIntensidade((data["confidence"] ?? 0).toDouble()),
            "local": local,
            "hora": formatHora(data["timestamp"] ?? ""),
          });
        }
      }
    }

    // Ordena do mais recente para o mais antigo
    listaEventos.sort((a, b) => b["hora"].compareTo(a["hora"]));

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
