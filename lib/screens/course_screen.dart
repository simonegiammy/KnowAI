import 'package:KnowAI/model/course.dart';
import 'package:KnowAI/style.dart';
import 'package:KnowAI/widgets/button.dart';
import 'package:KnowAI/widgets/course_tile.dart';
import 'package:KnowAI/widgets/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CourseScreen extends StatefulWidget {
  final Course course;
  const CourseScreen({super.key, required this.course});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.black,
      body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    SizedBox(
                      height: 48,
                      width: 48,
                      child: FittedBox(
                        child: AppButton(
                            iconPath: 'assets/icons/icon_back.svg',
                            onTap: () {
                              Navigator.pop(context);
                            }),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Hero(
                      tag: "Hero-Course",
                      child: CourseTile(
                          showBackground: false, course: widget.course))),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _buildLessonTime(),
                    Expanded(child: Container()),
                    _buildButtons(),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                margin: const EdgeInsets.only(top: 16),
                decoration: const BoxDecoration(
                    color: Color(0xff374B46),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32))),
                child: _buildContent(),
              ))
            ],
          )),
    );
  }

  _buildLessonTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Durata corso:",
          style: AppStyle.regular
              .copyWith(color: const Color(0xff858585), fontSize: 16),
        ),
        Text(
          "15 Lezioni: 1h 45m",
          style: AppStyle.semibold.copyWith(color: Colors.white, fontSize: 18),
        ),
      ],
    );
  }

  _buildButtons() {
    return Row(
      children: [
        SecondaryButton(
            text: "Salva",
            onTap: () {},
            iconPath: 'assets/icons/icon_bookmark.svg',
            color: AppStyle.greenDark),
        const SizedBox(
          width: 4,
        ),
        SecondaryButton(
            text: "Condividi",
            onTap: () {},
            iconPath: 'assets/icons/icon_send.svg',
            color: const Color(0xff33363F))
      ],
    );
  }

  _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Riguardo questo corso:",
          style: AppStyle.semibold.copyWith(fontSize: 20),
        ),
        Text(
          widget.course.description!,
          style: AppStyle.regular.copyWith(fontSize: 16),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          "Lezioni:",
          style: AppStyle.semibold.copyWith(fontSize: 20),
        ),
        Expanded(child: Container())
      ],
    );
  }
}
