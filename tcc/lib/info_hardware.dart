import 'package:flutter/material.dart';

class InfoHardware extends StatefulWidget {
  const InfoHardware({super.key});

  @override
  State<InfoHardware> createState() => _InfoHardwareState();
}

class _InfoHardwareState extends State<InfoHardware> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.deepPurple),
            ),
            Expanded(child: Container()),
            Container(),
          ],
        ),
      ),
    );
  }
}
