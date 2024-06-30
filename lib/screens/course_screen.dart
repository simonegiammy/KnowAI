import 'package:KnowAI/data_provider/courses_provider.dart';
import 'package:KnowAI/model/course.dart';
import 'package:KnowAI/model/lesson.dart';
import 'package:KnowAI/screens/lesson_screen.dart';
import 'package:KnowAI/style.dart';
import 'package:KnowAI/widgets/button.dart';
import 'package:KnowAI/widgets/course_tile.dart';
import 'package:KnowAI/widgets/lesson_tile.dart';
import 'package:KnowAI/widgets/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CourseScreen extends StatefulWidget {
  final Course course;
  const CourseScreen({super.key, required this.course});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  List<Lesson>? lessons;
  bool isSaved = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      isSaved = await CoursesProvider.isSaved(widget.course.id!) ?? false;
      lessons = await CoursesProvider.getLessons(widget.course.id!);
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.black,
      body: SafeArea(
          bottom: false,
          child: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  pinned: true,
                  automaticallyImplyLeading: false,
                  backgroundColor: AppStyle.black,
                  leading: null,
                  scrolledUnderElevation: 0,
                  collapsedHeight: 95,
                  expandedHeight: 258.0, // Altezza iniziale dell'immagine
                  flexibleSpace: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    var top = constraints.biggest.height;
                    var minHeight = kToolbarHeight;
                    var maxHeight = minHeight + 202;
                    var normalized =
                        (top - minHeight) / (maxHeight - minHeight);
                    bool isCollapsed = top <= kToolbarHeight + 50;
                    normalized = normalized.clamp(0.0, 1.0); // Ensure

                    return FlexibleSpaceBar(
                        expandedTitleScale: 1,
                        title: Column(
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
                                          iconPath:
                                              'assets/icons/icon_back.svg',
                                          onTap: () {
                                            Navigator.pop(context);
                                          }),
                                    ),
                                  ),
                                  if (normalized < 0.7)
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16, right: 16),
                                      child: Text(
                                        widget.course.title!,
                                        style: AppStyle.semibold
                                            .copyWith(fontSize: 24),
                                      ),
                                    )).animate().effect().fade()
                                ],
                              ),
                            ),
                            if (normalized > 0.7)
                              Opacity(
                                opacity: normalized,
                                child: Column(
                                  children: [
                                    CourseTile(
                                        showBackground: false,
                                        course: widget.course),
                                    if (normalized >= 1.0)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        child: Row(
                                          children: [
                                            _buildLessonTime(),
                                            Expanded(child: Container()),
                                            _buildButtons(),
                                          ],
                                        ),
                                      )
                                  ],
                                ),
                              ).animate().fadeIn(),
                          ],
                        ));
                  }),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    margin: const EdgeInsets.only(top: 0),
                    decoration: const BoxDecoration(
                        color: Color(0xff374B46),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32))),
                    child: _buildContent(),
                  ),
                )
              ])),
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
            text: isSaved ? "Salvato" : "Salva",
            onTap: () {
              CoursesProvider.addOrRemoveSavedCourse(widget.course.id!);
              setState(() {
                isSaved = !isSaved;
              });
            },
            iconPath: 'assets/icons/icon_bookmark.svg',
            color: AppStyle.greenDark),
        /* const SizedBox(
          width: 4,
        ),
        SecondaryButton(
            text: "Condividi",
            onTap: () {},
            iconPath: 'assets/icons/icon_send.svg',
            color: const Color(0xff33363F))*/
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
        Column(
          children: [
            for (Lesson l in lessons ?? [])
              GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return LessonScreen(lesson: l, c: widget.course);
                      },
                    ));
                  },
                  child: LessonTile(
                    lesson: l,
                    courseId: widget.course.id!,
                  )),
          ],
        )
      ],
    );
  }
}
