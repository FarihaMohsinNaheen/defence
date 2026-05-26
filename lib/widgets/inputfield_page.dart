// import 'package:flutter/material.dart';

// class InputField extends StatelessWidget {
//   final TextEditingController controller;
//   final TextInputType keyboardType;
//   final String labelText;
//   final String hintText;
//   final IconData prefixIcon;
//   final String? Function(String?)? validator;

//   const InputField({
//     super.key,
//     required this.controller,
//     this.keyboardType = TextInputType.text,
//     required this.labelText,
//     required this.hintText,
//     required this.prefixIcon,
//     this.validator,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       obscureText: keyboardType == TextInputType.visiblePassword,
//       validator: validator,
//       decoration: InputDecoration(
//         labelText: labelText,
//         hintText: hintText,
//         prefixIcon: Icon(prefixIcon),
//         border: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(50)),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// class InputField extends StatefulWidget {
//   final TextEditingController controller;
//   final TextInputType keyboardType;
//   final String labelText;
//   final String hintText;
//   final IconData prefixIcon;
//   final String? Function(String?)? validator;
//   final bool obscureText;

//   const InputField({
//     super.key,
//     required this.controller,
//     this.keyboardType = TextInputType.text,
//     required this.labelText,
//     required this.hintText,
//     required this.prefixIcon,
//     this.validator,
//     this.obscureText = false,
//   });

//   @override
//   State<InputField> createState() => _InputFieldState();
// }

// class _InputFieldState extends State<InputField> {
//   late bool _obscure;

//   @override
//   void initState() {
//     super.initState();
//     _obscure = widget.obscureText;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: widget.controller,
//       keyboardType: widget.keyboardType,
//       obscureText: _obscure,
//       validator: widget.validator,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       decoration: InputDecoration(
//         labelText: widget.labelText,
//         hintText: widget.hintText,
//         prefixIcon: Icon(widget.prefixIcon),

//         suffixIcon: widget.obscureText
//             ? IconButton(
//                 icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
//                 onPressed: () {
//                   setState(() {
//                     _obscure = !_obscure;
//                   });
//                 },
//               )
//             : null,

//         errorMaxLines: 2,

//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),

//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),

//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: const BorderSide(width: 2),
//         ),

//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: const BorderSide(color: Colors.red, width: 2),
//         ),

//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: const BorderSide(color: Colors.red, width: 2),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// class InputField extends StatefulWidget {
//   final TextEditingController controller;
//   final TextInputType keyboardType;
//   final String labelText;
//   final String hintText;
//   final IconData prefixIcon;
//   final String? Function(String?)? validator;
//   final bool obscureText;

//   const InputField({
//     super.key,
//     required this.controller,
//     this.keyboardType = TextInputType.text,
//     required this.labelText,
//     required this.hintText,
//     required this.prefixIcon,
//     this.validator,
//     this.obscureText = false,
//   });

//   @override
//   State<InputField> createState() => _InputFieldState();
// }

// class _InputFieldState extends State<InputField> {
//   late bool _obscure;

//   static const Color borderColor = Color(0xFFB0BEC5); // light grey

//   @override
//   void initState() {
//     super.initState();
//     _obscure = widget.obscureText;
//   }

//   OutlineInputBorder _border(Color color) {
//     return OutlineInputBorder(
//       borderRadius: BorderRadius.circular(16),
//       borderSide: BorderSide(color: color, width: 1.2),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: widget.controller,
//       keyboardType: widget.keyboardType,
//       obscureText: _obscure,
//       validator: widget.validator,
//       autovalidateMode: AutovalidateMode.onUserInteraction,

//       decoration: InputDecoration(
//         labelText: widget.labelText,
//         hintText: widget.hintText,
//         prefixIcon: Icon(widget.prefixIcon),

//         // ✅ THIS REMOVES YELLOW/DEFAULT UNDERLINE COMPLETELY
//         filled: true,
//         fillColor: Colors.white,

//         enabledBorder: _border(borderColor),
//         focusedBorder: _border(const Color(0xFF003366)),
//         errorBorder: _border(Colors.red),
//         focusedErrorBorder: _border(Colors.red),

//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 14,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final String? Function(String?)? validator;
  final bool obscureText;

  const InputField({
    super.key,
    required this.controller,
    this.keyboardType = TextInputType.text,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    this.validator,
    this.obscureText = false,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late bool _obscure;

  static const Color borderColor = Color(0xFFB0BEC5);

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
        prefixIcon: Icon(widget.prefixIcon),

        filled: true,
        fillColor: Colors.white,

       
        border: InputBorder.none,

        isDense: true,
        errorMaxLines: 2,

        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _obscure = !_obscure;
                  });
                },
              )
            : null,

        enabledBorder: _border(borderColor),
        focusedBorder: _border(const Color(0xFF003366)),
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
