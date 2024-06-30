import 'package:KnowAI/screens/create_new_course.dart';
import 'package:KnowAI/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppFab extends StatefulWidget {
  const AppFab({super.key});

  @override
  State<AppFab> createState() => _AppFabState();
}

class _AppFabState extends State<AppFab> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppStyle.greenDark,
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return const NewCourseScreen();
          },
        ));
      },
      child: SvgPicture.asset('assets/icons/icon_add.svg'),
    );
  }
}
