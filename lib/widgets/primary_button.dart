import 'package:flutter/material.dart';
import 'package:news_app/style.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  const PrimaryButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: AppStyle.greenDark),
        child: Center(
          child: Text(
            text,
            style: AppStyle.semibold,
          ),
        ),
      ),
    );
  }
}
