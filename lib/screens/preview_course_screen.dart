import 'package:KnowAI/data_provider/ai_provider.dart';
import 'package:KnowAI/data_provider/courses_provider.dart';
import 'package:KnowAI/model/course.dart';
import 'package:KnowAI/model/lesson.dart';
import 'package:KnowAI/screens/lesson_screen.dart';
import 'package:KnowAI/style.dart';
import 'package:KnowAI/widgets/button.dart';
import 'package:KnowAI/widgets/course_tile.dart';
import 'package:KnowAI/widgets/lesson_tile.dart';
import 'package:KnowAI/widgets/primary_button.dart';
import 'package:KnowAI/widgets/retry_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PreviewCourseScreen extends StatefulWidget {
  final String answers;
  final String topic;
  const PreviewCourseScreen(
      {super.key, required this.answers, required this.topic});

  @override
  State<PreviewCourseScreen> createState() => _PreviewCourseScreenState();
}

class _PreviewCourseScreenState extends State<PreviewCourseScreen> {
  List<Lesson>? lessons;
  Course? course;
  String? imageUrl;
  bool loadingLessons = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      course = await AIProvider.createCourse(widget.topic, widget.answers);

      if (mounted) {
        setState(() {
          loadingLessons = true;
        });
      }
      try {
        lessons = await AIProvider.generateLessons(
            course!.description!, widget.answers, course!.numberLessons!);
      } catch (e) {
        print(e);
        /*
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return RetryDialog(onTap: () async {
              lessons = await AIProvider.generateLessons(
                  course!.description!, widget.answers, course!.numberLessons!);
            });
          },
        );*/
      }
      if (mounted) {
        setState(() {
          loadingLessons = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (course != null) {
      return Scaffold(
          backgroundColor: AppStyle.black,
          body: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
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
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, top: 4),
                          child: Text(
                            "KnowAI ti propone questo corso:",
                            style: AppStyle.semibold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      course!.category!,
                                      style: AppStyle.regular.copyWith(
                                          color: const Color(0xff858585),
                                          fontSize: 16),
                                    ),
                                    Text(
                                      course!.title!,
                                      style: AppStyle.semibold
                                          .copyWith(fontSize: 24, height: 1),
                                    ),
                                    _buildLessonTime(),
                                  ],
                                ),
                              ),
                              if (course?.imageUrl != null)
                                Container(
                                  width: 90,
                                  height: 90,
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      color:
                                          AppStyle.greenDark.withOpacity(0.3),
                                      border: Border.all(
                                          color: const Color(0xfff0f0f0)
                                              .withOpacity(0.3)),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12))),
                                  child: Image.network(course!.imageUrl!),
                                )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SecondaryButton(
                              color: AppStyle.greenLight,
                              iconPath: "assets/icons/icon_generate.svg",
                              text: "Completa la creazione del corso",
                              onTap: () {
                                CoursesProvider.createCourse(course!);
                                CoursesProvider.createLessons(
                                    lessons!, course!.id!);
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                              }),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          margin: const EdgeInsets.only(top: 16),
                          decoration: const BoxDecoration(
                              color: Color(0xff374B46),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(32),
                                  topRight: Radius.circular(32))),
                          child: _buildContent(),
                        ),
                      ],
                    )
                  ],
                ),
              )));
    }
    return const Center(
      child: CircularProgressIndicator(),
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
          "${course!.numberLessons} Lezioni",
          style: AppStyle.semibold.copyWith(color: Colors.white, fontSize: 18),
        ),
      ],
    );
  }

  _buildContent() {
    if (course != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Riguardo questo corso:",
            style: AppStyle.semibold.copyWith(fontSize: 20),
          ),
          Text(
            course!.description!,
            style: AppStyle.regular.copyWith(fontSize: 16),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            "Lezioni:",
            style: AppStyle.semibold.copyWith(fontSize: 20),
          ),
          if (loadingLessons) ...[
            const Center(
              child: CircularProgressIndicator(),
            ),
            const SizedBox(
              height: 8,
            ),
            Center(
              child: Text(
                "Kai sta generando il tuo piano di apprendimnento personalizzato",
                style: AppStyle.semibold,
              ),
            )
          ],
          Column(
            children: [
              for (Lesson l in lessons ?? [])
                LessonTile(
                  lesson: l,
                  isPreview: true,
                  courseId: "",
                ),
            ],
          ),
        ],
      );
    }
  }
}
