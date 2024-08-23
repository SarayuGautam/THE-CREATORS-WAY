import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BlogEditor extends StatelessWidget {
  const BlogEditor({
    required this.controller,
    required this.hintText,
    super.key,
  });

  final TextEditingController controller;
  final String hintText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      maxLines: null,
      validator: (value) {
        return value!.trim().isEmpty ? '$hintText in missing!' : null;
      },
    );
  }
}
