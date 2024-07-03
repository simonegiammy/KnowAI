import 'dart:math';

import 'package:KnowAI/screens/create_new_course.dart';
import 'package:KnowAI/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppFab extends StatefulWidget {
  final Function onTap;
  final String iconPath;
  const AppFab({super.key, required this.onTap, required this.iconPath});

  @override
  State<AppFab> createState() => _AppFabState();
}

class _AppFabState extends State<AppFab> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppStyle.greenDark,
      onPressed: () {
        widget.onTap();
      },
      child: SvgPicture.asset(widget.iconPath),
    );
  }
}
