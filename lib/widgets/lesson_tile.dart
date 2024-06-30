import 'package:KnowAI/data_provider/courses_provider.dart';
import 'package:KnowAI/model/lesson.dart';
import 'package:KnowAI/style.dart';
import 'package:KnowAI/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LessonTile extends StatefulWidget {
  final Lesson lesson;
  final String courseId;
  bool isPreview = false;
  LessonTile(
      {super.key,
      required this.lesson,
      this.isPreview = false,
      required this.courseId});

  @override
  State<LessonTile> createState() => _LessonTileState();
}

class _LessonTileState extends State<LessonTile> {
  bool isCompleted = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      isCompleted = await CoursesProvider.isCompleted(
              "${widget.lesson.id!}", widget.courseId) ??
          false;
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
          color: AppStyle.black.withOpacity(0.6),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                "${widget.lesson.id}. ${widget.lesson.title!}",
                style: AppStyle.semibold
                    .copyWith(color: Colors.white, fontSize: 18, height: 1.1),
              )),
              const SizedBox(
                width: 64,
              ),
              SvgPicture.asset(
                'assets/icons/icon_right.svg',
                width: 36,
              )
            ],
          ),
          const SizedBox(
            height: 6,
          ),
          if (!widget.isPreview) ...[
            Row(
              children: [
                Expanded(
                    child: Row(
                  children: [
                    SvgPicture.asset('assets/icons/icon_time.svg'),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      "${AppUtils.getMinutesReading(widget.lesson.completeText ?? widget.lesson.content ?? "")} minuti",
                      style: AppStyle.semibold.copyWith(
                          color: const Color(0xff858585), fontSize: 16),
                    ),
                  ],
                )),
                _buildButton()
              ],
            )
          ]
        ],
      ),
    );
  }

  _buildButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: isCompleted ? AppStyle.greenLight : AppStyle.red),
      child: Text(
        isCompleted ? "Completata  ✅" : "Inizia subito  👩🏻‍💻",
        style: AppStyle.semibold.copyWith(color: Colors.white, fontSize: 14),
      ),
    );
  }
}
