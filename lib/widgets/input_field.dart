import 'package:flutter/material.dart';
import 'package:KnowAI/style.dart';
import 'package:flutter_svg/svg.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  int maxLines = 1;
  String? iconPath;
  InputField(
      {super.key, required this.controller, this.maxLines = 1, this.iconPath});

  @override
  Widget build(BuildContext context) {
    return TextField(
      minLines: 1,
      maxLines: maxLines,
      style: AppStyle.regular,
      controller: controller,
      decoration: InputDecoration(
          fillColor: AppStyle.gray,
          filled: true,
          prefixIconConstraints: const BoxConstraints(
              maxWidth: 35, minWidth: 35, maxHeight: 25, minHeight: 25),
          prefixIcon: iconPath != null
              ? SvgPicture.asset(
                  iconPath!,
                  width: 20,
                )
              : null,
          border: OutlineInputBorder(
              borderSide: BorderSide(color: AppStyle.gray),
              borderRadius: const BorderRadius.all(Radius.circular(8)))),
    );
  }
}
