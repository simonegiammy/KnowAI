import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_app/style.dart';

class AppButton extends StatelessWidget {
  final String iconPath;
  final Function() onTap;
  const AppButton({super.key, required this.iconPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: 48,
          height: 48,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: AppStyle.greenLight,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: SvgPicture.asset(iconPath)),
    );
  }
}
