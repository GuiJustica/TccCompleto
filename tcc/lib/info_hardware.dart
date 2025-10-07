import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:tcc/constants/CoresDefinidas/branco_sujo.dart';
import 'package:tcc/constants/CoresDefinidas/preto_letra.dart';
import 'package:tcc/constants/CoresDefinidas/roxo_tres.dart';

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
  bool notificacaoVisual = true;
  bool notificacaoSom = false;
  bool notificacaoVibracao = false;
  _Rooms? selectedRoom;
  bool carregouDados = false;

  void salvarNoFirebase(String deviceId, String userId) async {
    await FirebaseDatabase.instance
        .ref('usuarios/$userId/dispositivos/$deviceId')
        .update({
          'ambiente': selectedRoom?.label ?? 'Indefinido',
          'notificacaoVisual': notificacaoVisual,
          'notificacaoSom': notificacaoSom,
          'notificacaoVibracao': notificacaoVibracao,
        });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Configurações salvas com sucesso')));
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
                    style: TextStyle(
                      color: pretoLetra,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  CheckboxListTile(
                    value: notificacaoVisual,
                    title: Text(
                      'Notificação Visual',
                      style: TextStyle(
                        color: pretoLetra,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                    activeColor: fundoRoxoTres,
                    onChanged: (value) {
                      setModalState(() => notificacaoVisual = value!);
                    },
                  ),
                  CheckboxListTile(
                    value: notificacaoSom,
                    title: Text(
                      'Notificação com Som',
                      style: TextStyle(
                        color: pretoLetra,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                    activeColor: fundoRoxoTres,
                    onChanged: (value) {
                      setModalState(() => notificacaoSom = value!);
                    },
                  ),
                  CheckboxListTile(
                    value: notificacaoVibracao,
                    title: Text(
                      'Notificação com Vibração',
                      style: TextStyle(
                        color: pretoLetra,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                    activeColor: fundoRoxoTres,
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
                      setState(() {});
                    },
                    icon: Icon(Icons.check),
                    label: Text('Salvar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: fundoRoxoTres,
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
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final String deviceId = args['id'];
    final String nomeDispositivo = args['nome'] ?? 'Sem nome';
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseDatabase.instance.ref(
      'usuarios/$userId/dispositivos/$deviceId',
    );

    return Scaffold(
      backgroundColor: fundoBranco,
      body: SafeArea(
        child: StreamBuilder<DatabaseEvent>(
          stream: ref.onValue,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = snapshot.data!.snapshot.value as Map;

            if (!carregouDados) {
              notificacaoVisual = data['notificacaoVisual'] ?? true;
              notificacaoSom = data['notificacaoSom'] ?? false;
              notificacaoVibracao = data['notificacaoVibracao'] ?? false;

              selectedRoom = _Rooms.values.firstWhere(
                (room) => room.label == (data['ambiente'] ?? 'Sala'),
                orElse: () => _Rooms.sala,
              );

              carregouDados = true;
            }

            return Column(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: fundoRoxoTres,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        nomeDispositivo,
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
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
                                  color: pretoLetra,
                                  fontFamily: 'Urbanist',
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
                                  side: const BorderSide(color: fundoRoxoTres),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  "Ver todos os registros",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: pretoLetra,
                                    fontFamily: 'Urbanist',
                                  ),
                                ),
                              ),
                              const Divider(thickness: 1, color: fundoRoxoTres),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: const [
                                      Text(
                                        "Horário",
                                        style: TextStyle(
                                          color: pretoLetra,
                                          fontFamily: 'Urbanist',
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
                                          color: pretoLetra,
                                          fontFamily: 'Urbanist',
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
                                          color: pretoLetra,
                                          fontFamily: 'Urbanist',
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
                        FilledButton.tonal(
                          onPressed: () => _abrirConfiguracoes(context),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.deepPurple.shade100,
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
                              color: pretoLetra,
                              fontFamily: 'Urbanist',
                            ),
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: fundoRoxoTres,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text(
                        'Salvar',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () => salvarNoFirebase(deviceId, userId),
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
