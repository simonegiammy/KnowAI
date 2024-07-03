import 'package:KnowAI/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  bool isLoading = false;
  PrimaryButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.isLoading = false});

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
          child: isLoading
              ? const CircularProgressIndicator()
              : Text(
                  text,
                  style: AppStyle.semibold,
                ),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  final String iconPath;
  final Color color;
  const SecondaryButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.iconPath,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: color),
        child: Row(
          children: [
            SvgPicture.asset(iconPath),
            const SizedBox(
              width: 4,
            ),
            Text(
              text,
              style: AppStyle.semibold.copyWith(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
