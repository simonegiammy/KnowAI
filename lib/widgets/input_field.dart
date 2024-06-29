import 'package:flutter/material.dart';
import 'package:news_app/style.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  const InputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: AppStyle.regular,
      controller: controller,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: AppStyle.gray),
              borderRadius: const BorderRadius.all(Radius.circular(8)))),
    );
  }
}
