import 'package:flutter/material.dart';
import 'package:tcc/constants/CoresDefinidas/preto_azulado.dart';
import 'package:tcc/constants/CoresDefinidas/roxo_tres.dart';

class MyTextfieldWifi extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final TextEditingController? mainPasswordController;
  final IconData? icon;

  const MyTextfieldWifi({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.icon,
    this.mainPasswordController,
  });

  @override
  State<MyTextfieldWifi> createState() => _MyTextfieldWifiState();
}

class _MyTextfieldWifiState extends State<MyTextfieldWifi> {
  late bool _obscureText;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: TextField(
            controller: widget.controller,
            obscureText: _obscureText,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Colors.grey.shade600),
              fillColor: Colors.white,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 18,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              suffixIcon:
                  widget.isPassword
                      ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: fundoRoxoTres,
                        ),
                        onPressed: _toggleVisibility,
                      )
                      : widget.icon != null
                      ? Icon(widget.icon, color: fundoRoxoTres)
                      : null,
            ),
          ),
        ),
      ],
    );
  }
}
