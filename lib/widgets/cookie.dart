import 'package:flutter/material.dart';
import 'package:news_app/style.dart';

class CookieTile extends StatelessWidget {
  final String text;
  final bool selected;
  const CookieTile({super.key, required this.text, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: BoxDecoration(
          color: selected ? AppStyle.greenLight : Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(36))),
      child: Text(
        text,
        style: AppStyle.regular.copyWith(
            fontSize: 18, color: selected ? Colors.white : Colors.black),
      ),
    );
  }
}
