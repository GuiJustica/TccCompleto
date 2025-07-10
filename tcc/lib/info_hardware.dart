import 'package:flutter/material.dart';

bool notificacaoVisual = true;
bool notificacaoSom = false;
bool notificacaoVibracao = false;

enum _Rooms {
  sala('Sala'),
  quarto('Quarto'),
  cozinha('Cozinha');

  final String label;
  const _Rooms(this.label);
}

class InfoHardware extends StatefulWidget {
  const InfoHardware({super.key});

  @override
  State<InfoHardware> createState() => _InfoHardwareState();
}

class _InfoHardwareState extends State<InfoHardware> {
  _Rooms? selectedRoom = _Rooms.sala;

  void salvarNoFirebase() async {
    // Exemplo usando Firebase Realtime Database
    // final userId = FirebaseAuth.instance.currentUser?.uid;
    // final deviceId = "id_do_dispositivo";

    // await FirebaseDatabase.instance
    //     .ref()
    //     .child('usuarios/$userId/dispositivos/$deviceId')
    //     .set({'ambiente': selectedRoom?.label ?? 'Indefinido'});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ambiente "${selectedRoom?.label}" salvo!')),
    );
  }

  void _abrirConfiguracoes(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Configurações de Notificação',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  CheckboxListTile(
                    value: notificacaoVisual,
                    title: Text('Notificação Visual'),
                    activeColor: Colors.deepPurple,
                    onChanged: (value) {
                      setModalState(() => notificacaoVisual = value!);
                    },
                  ),
                  CheckboxListTile(
                    value: notificacaoSom,
                    title: Text('Notificação com Som'),
                    activeColor: Colors.deepPurple,
                    onChanged: (value) {
                      setModalState(() => notificacaoSom = value!);
                    },
                  ),
                  CheckboxListTile(
                    value: notificacaoVibracao,
                    title: Text('Notificação com Vibração'),
                    activeColor: Colors.deepPurple,
                    onChanged: (value) {
                      setModalState(() => notificacaoVibracao = value!);
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Configurações salvas')),
                      );
                      setState(
                        () {},
                      ); // atualiza o estado do widget pai, se necessário
                    },
                    icon: Icon(Icons.check),
                    label: Text('Salvar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Cabeçalho fixo
            Container(
              height: 180,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Nome Dispositivo",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Image.asset(
                    'assets/images/rasp.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),

            // Conteúdo rolável
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Ambiente
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            "Ambiente:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                              ),
                              items:
                                  _Rooms.values.map((room) {
                                    return DropdownMenuItem<_Rooms>(
                                      value: room,
                                      child: Text(room.label),
                                    );
                                  }).toList(),
                              onChanged: (_Rooms? room) {
                                setState(() => selectedRoom = room);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Último Registro
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.deepPurple),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Ver todos os registros",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                          const Divider(thickness: 1, color: Colors.deepPurple),

                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: const [
                                  Text(
                                    "Horário",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text("14:35"),
                                ],
                              ),
                              Column(
                                children: const [
                                  Text(
                                    "Som",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text("Cachorro Latindo"),
                                ],
                              ),
                              Column(
                                children: const [
                                  Text(
                                    "Intensidade",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text("0.82"),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Configurações avançadas
                    FilledButton.tonal(
                      onPressed: () => _abrirConfiguracoes(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade100,
                        foregroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Configurações avançadas',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),

                    const SizedBox(height: 100), // Espaço para o botão final
                  ],
                ),
              ),
            ),

            // Botão salvar fixo
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text(
                    'Salvar',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  onPressed: salvarNoFirebase,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
