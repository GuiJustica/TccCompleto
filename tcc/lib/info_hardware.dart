import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:tcc/constants/CoresDefinidas/branco_sujo.dart';
import 'package:tcc/constants/CoresDefinidas/roxo_tres.dart';

enum _Rooms {
  sala('Sala'),
  quarto('Quarto'),
  cozinha('Cozinha'),
  garagem('Garagem'),
  outro('Outro');

  final String label;
  const _Rooms(this.label);
}

class InfoHardware extends StatefulWidget {
  const InfoHardware({super.key});

  @override
  State<InfoHardware> createState() => _InfoHardwareState();
}

class _InfoHardwareState extends State<InfoHardware> {
  bool notificacaoVisual = true;
  bool notificacaoSom = false;
  bool notificacaoVibracao = false;
  _Rooms? selectedRoom;
  bool ligado = false;
  final TextEditingController nomeController = TextEditingController();

  bool carregado = false;

  void salvarNoFirebase(String deviceId, String userId) async {
    await FirebaseDatabase.instance
        .ref('usuarios/$userId/dispositivos/$deviceId')
        .update({
          'nome':
              nomeController.text.trim().isEmpty
                  ? 'Sem nome'
                  : nomeController.text.trim(),
          'ambiente': selectedRoom?.label ?? 'Indefinido',
          'notificacaoVisual': notificacaoVisual,
          'notificacaoSom': notificacaoSom,
          'notificacaoVibracao': notificacaoVibracao,
        });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Configurações salvas com sucesso')),
    );
  }

  void removerDispositivo(String deviceId, String userId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Remover dispositivo'),
            content: const Text(
              'Tem certeza que deseja remover este dispositivo?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Remover'),
              ),
            ],
          ),
    );
    if (confirm != true) return;

    await FirebaseDatabase.instance
        .ref('usuarios/$userId/dispositivos/$deviceId')
        .remove();

    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, 'home', (_) => false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Dispositivo removido')));
  }

  void carregarDadosIniciais(
    String deviceId,
    String userId,
    String nomeDispositivo,
  ) async {
    final snapshot =
        await FirebaseDatabase.instance
            .ref('usuarios/$userId/dispositivos/$deviceId')
            .get();

    final data = snapshot.value as Map<dynamic, dynamic>?;

    if (data != null && mounted) {
      setState(() {
        nomeController.text = data['nome'] ?? nomeDispositivo;
        notificacaoVisual = data['notificacaoVisual'] ?? true;
        notificacaoSom = data['notificacaoSom'] ?? false;
        notificacaoVibracao = data['notificacaoVibracao'] ?? false;
        selectedRoom = _Rooms.values.firstWhere(
          (r) => r.label == (data['ambiente'] ?? 'Sala'),
          orElse: () => _Rooms.sala,
        );
        carregado = true;
      });
    } else {
      setState(() => carregado = true);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!carregado) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      final String deviceId = args['id'];
      final String nomeDispositivo = args['nome'] ?? 'Sem nome';
      final userId = FirebaseAuth.instance.currentUser!.uid;
      carregarDadosIniciais(deviceId, userId, nomeDispositivo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final String deviceId = args['id'];
    final userId = FirebaseAuth.instance.currentUser!.uid;

    if (!carregado) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final ref = FirebaseDatabase.instance.ref(
      'usuarios/$userId/dispositivos/$deviceId',
    );

    return Scaffold(
      backgroundColor: fundoBranco,
      body: SafeArea(
        child: StreamBuilder<DatabaseEvent>(
          stream: ref.onValue,
          builder: (context, snapshot) {
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  color: fundoRoxoTres,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const Spacer(),
                      Text(
                        nomeController.text.isNotEmpty
                            ? nomeController.text
                            : 'Sem nome',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => removerDispositivo(deviceId, userId),
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.redAccent,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Nome
                                TextField(
                                  controller: nomeController,
                                  decoration: const InputDecoration(
                                    labelText: "Nome do dispositivo",
                                    border: OutlineInputBorder(),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Ambiente
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      209,
                                      196,
                                      233,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      const Text(
                                        "Ambiente:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: DropdownButtonFormField<_Rooms>(
                                          value: selectedRoom,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            filled: true,
                                            fillColor: Colors.white,
                                          ),
                                          items:
                                              _Rooms.values
                                                  .map(
                                                    (room) => DropdownMenuItem<
                                                      _Rooms
                                                    >(
                                                      value: room,
                                                      child: Text(room.label),
                                                    ),
                                                  )
                                                  .toList(),
                                          onChanged: (_Rooms? room) {
                                            if (!mounted) return;
                                            setState(() => selectedRoom = room);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Notificações
                                const Text(
                                  "Notificações",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                CheckboxListTile(
                                  value: notificacaoVisual,
                                  title: const Text('Notificação Visual'),
                                  activeColor: fundoRoxoTres,
                                  onChanged:
                                      (v) => setState(
                                        () => notificacaoVisual = v ?? true,
                                      ),
                                ),
                                CheckboxListTile(
                                  value: notificacaoSom,
                                  title: const Text('Notificação com Som'),
                                  activeColor: fundoRoxoTres,
                                  onChanged:
                                      (v) => setState(
                                        () => notificacaoSom = v ?? false,
                                      ),
                                ),
                                CheckboxListTile(
                                  value: notificacaoVibracao,
                                  title: const Text('Notificação com Vibração'),
                                  activeColor: fundoRoxoTres,
                                  onChanged:
                                      (v) => setState(
                                        () => notificacaoVibracao = v ?? false,
                                      ),
                                ),
                                const SizedBox(height: 20),

                                // Status
                                SwitchListTile.adaptive(
                                  title: const Text(
                                    'Status do dispositivo',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  value: ligado,
                                  onChanged: (v) => setState(() => ligado = v),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.history),
                          label: const Text("Ver todos registros"),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () => salvarNoFirebase(deviceId, userId),
                          icon: const Icon(Icons.save, color: Colors.white),
                          label: const Text(
                            "Salvar",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 52),
                            backgroundColor: fundoRoxoTres,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
