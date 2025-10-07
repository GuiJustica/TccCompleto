import 'package:flutter/material.dart';
import 'package:tcc/constants/CoresDefinidas/preto_azulado.dart';
import 'package:tcc/constants/CoresDefinidas/roxo_tres.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class MyTextformfield extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final bool enabled;
  final IconData? icon;
  final bool isPhone;
  const MyTextformfield({
    super.key,
    required this.controller,
    required this.hintText,
    this.enabled = true,
    this.isPassword = false,
    this.icon,
    this.isPhone = false,
  });
  @override
  State<MyTextformfield> createState() => _MyTextfieldState();
}

class _MyTextfieldState extends State<MyTextformfield> {
  late bool _obscureText;
  bool _isValid = true;
  MaskTextInputFormatter? phoneFormatter;
  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    if (widget.isPhone) {
      phoneFormatter = MaskTextInputFormatter(
        mask: '(##) #####-####',
        filter: {"#": RegExp(r'\d')},
        type: MaskAutoCompletionType.lazy,
      );
      widget.controller.addListener(() {
        final text = widget.controller.text;
        final regex = RegExp(r'^\(\d{2}\) 9\d{4}-\d{4}$');

        setState(() {
          _isValid = text.isEmpty || regex.hasMatch(text);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        enabled: widget.enabled,
        keyboardType: widget.isPhone ? TextInputType.phone : TextInputType.text,
        inputFormatters:
            widget.isPhone && phoneFormatter != null
                ? [phoneFormatter!] // aplica a máscara
                : null,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: pretoAzulado,
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color:
                  widget.isPhone
                      ? (_isValid ? fundoRoxoTres : Colors.red)
                      : fundoRoxoTres,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color:
                  widget.isPhone
                      ? (_isValid ? fundoRoxoTres : Colors.red)
                      : fundoRoxoTres,
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          suffixIcon:
              widget.isPhone && widget.controller.text.isNotEmpty
                  ? (_isValid
                      ? const Icon(Icons.check, color: Colors.green)
                      : const Icon(Icons.close, color: Colors.red))
                  : widget.icon != null
                  ? Icon(widget.icon, color: fundoRoxoTres)
                  : null,
        ),
      ),
    );
  }
}
