import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  const AuthField({
    required this.hintText,
    required this.controller,
    super.key,
    this.obscureText = false,
  });
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      validator: (value) => value!.isEmpty ? '$hintText is missing!' : null,
    );
  }
}
