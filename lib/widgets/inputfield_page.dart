import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final String? Function(String?)? validator;
  final bool obscureText;
  final int? maxLength;

  const InputField({
    super.key,
    required this.controller,
    this.keyboardType = TextInputType.text,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    this.validator,
    this.obscureText = false,
    this.maxLength,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late bool _obscure;

  static const Color borderColor = Color(0xFFB0BEC5);
  static const Color primaryBlue = Color(0xFF003366);

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: 1.2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: _obscure,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,

      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixIcon: Icon(widget.prefixIcon, color: primaryBlue),

        filled: true,
        fillColor: Colors.white,

        border: InputBorder.none,
        isDense: true,
        errorMaxLines: 2,

        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscure = !_obscure;
                  });
                },
              )
            : null,

        enabledBorder: _border(borderColor),
        focusedBorder: _border(primaryBlue),
        errorBorder: _border(Colors.red),
        focusedErrorBorder: _border(Colors.red),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
