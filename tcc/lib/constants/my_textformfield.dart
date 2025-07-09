import 'package:flutter/material.dart';

class MyTextformfield extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final bool enabled;
  final IconData? icon;

  const MyTextformfield({
    super.key,
    required this.controller,
    required this.hintText,
    this.enabled = true,
    this.isPassword = false,
    this.icon,
  });

  @override
  State<MyTextformfield> createState() => _MyTextfieldState();
}

class _MyTextfieldState extends State<MyTextformfield> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),

      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        enabled: widget.enabled,

        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: Colors.deepPurple.shade100,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.deepPurple),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
