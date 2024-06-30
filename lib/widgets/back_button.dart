import 'package:KnowAI/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        color: AppStyle.gray,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform.flip(
            flipX: true,
            child: SvgPicture.asset(
              'assets/icons/icon_right.svg',
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            'indietro',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF181818),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 0,
              letterSpacing: 0.09,
            ),
          ),
        ],
      ),
    );
  }
}
