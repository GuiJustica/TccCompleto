import 'package:flutter/material.dart';
import 'package:tcc/constants/CoresDefinidas/preto_azulado.dart';
import 'package:tcc/constants/CoresDefinidas/roxo_tres.dart';

class MyTextfield extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final bool isConfirmPassword;
  final TextEditingController? mainPasswordController;
  final IconData? icon;
  final bool isEmail;

  const MyTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.icon,
    this.isEmail = false,
    this.isConfirmPassword = false,
    this.mainPasswordController,
  });

  @override
  State<MyTextfield> createState() => _MyTextfieldState();
}

class _MyTextfieldState extends State<MyTextfield> {
  late bool _obscureText;
  bool _isValid = false;

  // requisitos da senha
  bool hasMinLength = false;
  bool hasUppercase = false;
  bool hasNumber = false;
  bool hasSpecialChar = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;

    widget.controller.addListener(_validate);
    widget.mainPasswordController?.addListener(_validate);
  }

  void _validate() {
    // se for confirmação, valida com base na senha principal
    final text =
        widget.isConfirmPassword && widget.mainPasswordController != null
            ? widget.mainPasswordController!.text
            : widget.controller.text;

    if (widget.isEmail) {
      setState(() {
        if (widget.controller.text.isEmpty) {
          _isValid = false;
        } else {
          _isValid = RegExp(
            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(com|org|net|edu|gov|mil|io|live)$",
            caseSensitive: false,
          ).hasMatch(widget.controller.text);
        }
      });
    }

    if (widget.isPassword || widget.isConfirmPassword) {
      setState(() {
        hasMinLength = text.length >= 8;
        hasUppercase = text.contains(RegExp(r'[A-Z]'));
        hasNumber = text.contains(RegExp(r'[0-9]'));
        hasSpecialChar = text.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
      });
    }
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Widget _buildRequirement(String text, bool met) {
    return Row(
      children: [
        Icon(
          met ? Icons.check_circle : Icons.circle_outlined,
          color: met ? Colors.green : pretoAzulado,
          size: 18,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: met ? Colors.green : pretoAzulado,
            decoration: met ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
      ],
    );
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
              fillColor: Colors.grey.shade200,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 18,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color:
                      widget.isEmail
                          ? (_isValid
                              ? Colors.green
                              : (widget.controller.text.isEmpty
                                  ? Colors.white
                                  : Colors.red))
                          : Colors.white,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color:
                      widget.isEmail
                          ? (_isValid
                              ? Colors.green
                              : (widget.controller.text.isEmpty
                                  ? Colors.grey.shade400
                                  : Colors.red))
                          : Colors.grey.shade400,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              suffixIcon:
                  widget.isPassword || widget.isConfirmPassword
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
                      : widget.isEmail && widget.controller.text.isNotEmpty
                      ? (_isValid
                          ? const Icon(Icons.check, color: Colors.green)
                          : const Icon(Icons.close, color: Colors.red))
                      : null,
            ),
          ),
        ),

        // requisitos aparecem só no campo de CONFIRMAR SENHA
        if (widget.isConfirmPassword) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRequirement("Mínimo 8 caracteres", hasMinLength),
                _buildRequirement("1 letra maiúscula", hasUppercase),
                _buildRequirement("1 número", hasNumber),
                _buildRequirement("1 caractere especial", hasSpecialChar),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
