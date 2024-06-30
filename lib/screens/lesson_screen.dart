import 'package:KnowAI/data_provider/ai_provider.dart';
import 'package:KnowAI/data_provider/courses_provider.dart';
import 'package:KnowAI/model/course.dart';
import 'package:KnowAI/model/lesson.dart';
import 'package:KnowAI/model/quiz.dart';
import 'package:KnowAI/screens/quiz_screen.dart';
import 'package:KnowAI/style.dart';
import 'package:KnowAI/widgets/button.dart';
import 'package:KnowAI/widgets/primary_button.dart';
import 'package:KnowAI/widgets/quiz_tile.dart';
import 'package:KnowAI/widgets/retry_dialog.dart';
import 'package:KnowAI/widgets/youtube_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class LessonScreen extends StatefulWidget {
  final Lesson lesson;
  final Course c;
  const LessonScreen({super.key, required this.lesson, required this.c});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  bool isLoading = false;
  bool isCompleted = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      isCompleted = await CoursesProvider.isCompleted(
              "${widget.lesson.id!}", widget.c.id!) ??
          false;
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
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
                  Text(
                    "Lezione ${widget.lesson.id} - ${widget.c.title}",
                    style: AppStyle.regular
                        .copyWith(color: const Color(0xff858585), fontSize: 16),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "${widget.lesson.title}",
                    style: AppStyle.title.copyWith(fontSize: 24, height: 1.1),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Markdown(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(),
                    shrinkWrap: true,
                    data: widget.lesson.content!,
                    styleSheet: MarkdownStyleSheet(
                        h1: const TextStyle(color: Colors.blue),
                        p: AppStyle.regular.copyWith(fontSize: 18)),
                    //style: AppStyle.regular.copyWith(fontSize: 18),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 2,
                    margin: const EdgeInsets.only(
                        top: 16, bottom: 12, left: 64, right: 64),
                    color: const Color(0xffd9d9d9),
                  ),
                  if (widget.lesson.completeText == null && !isLoading)
                    PrimaryButton(
                        text: "Genera contenuto lezione integrale",
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            widget.lesson.completeText =
                                await AIProvider.createLessonText(
                                    widget.lesson);

                            setState(() {
                              CoursesProvider.updateLesson(
                                  widget.lesson, widget.c.id!);
                              isLoading = false;
                            });
                          } catch (e) {
                            showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return RetryDialog(
                                  onTap: () {},
                                );
                              },
                            );
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }),
                  if (isLoading) const CircularProgressIndicator(),
                  if (widget.lesson.completeText != null)
                    Markdown(
                      data: widget.lesson.completeText!,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(),
                      shrinkWrap: true,
                      styleSheet: MarkdownStyleSheet(
                          code: TextStyle(
                              //  backgroundColor: AppStyle.greenDark,
                              color: AppStyle.greenDark,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'SFPro-Text'),
                          h1: const TextStyle(color: Colors.blue),
                          p: AppStyle.regular.copyWith(fontSize: 18)),
                      //style: AppStyle.regular.copyWith(fontSize: 18),
                    ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "🙋🏻‍♂️ E’ tempo di quiz",
                    style: AppStyle.title.copyWith(fontSize: 18, height: 1.1),
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                      text: "0/${widget.lesson.quizes?.length}",
                      style: AppStyle.semibold.copyWith(
                          color: const Color(0xff858585), fontSize: 16),
                    ),
                    TextSpan(
                      text: " completati",
                      style: AppStyle.regular.copyWith(
                          color: const Color(0xff858585), fontSize: 16),
                    )
                  ])),
                  SizedBox(
                    height: 68,
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                      padding: const EdgeInsets.only(top: 8),
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (Quiz q in widget.lesson.quizes ?? [])
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return QuizScreen(
                                          quiz: q,
                                        );
                                      },
                                    ));
                                  },
                                  child: QuizTile(quiz: q))),
                        isLoading
                            ? const CircularProgressIndicator()
                            : AppButton(
                                iconPath: "assets/icons/icon_add.svg",
                                onTap: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  Quiz? q = await AIProvider.generateQuiz(
                                      widget.lesson.completeText ??
                                          widget.lesson.content!);
                                  if (q != null) {
                                    Lesson l = widget.lesson;
                                    (l.quizes ?? []).add(q);
                                    setState(() {
                                      isLoading = false;
                                    });
                                    CoursesProvider.updateLesson(
                                        l, widget.c.id!);
                                  }
                                })
                      ],
                    ),
                  ),
                  if ((widget.lesson.relatedLinks ?? []).isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        "Video utili per la lezione",
                        style: AppStyle.regular.copyWith(
                            color: const Color(0xff858585), fontSize: 16),
                      ),
                    ),
                  SizedBox(
                    height: 160,
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                      padding: const EdgeInsets.only(top: 8),
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (String s in widget.lesson.relatedLinks ?? [])
                          Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: YoutubePreview(link: s))
                      ],
                    ),
                  ),
                  if (!isCompleted)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: PrimaryButton(
                          text: "Segna lezione come completata",
                          onTap: () async {
                            await CoursesProvider.addOrRemoveCompletedLesson(
                                "${widget.lesson.id!}", widget.c.id!);
                            setState(() {
                              isCompleted = !isCompleted;
                            });
                          }),
                    )
                ],
              ),
            ),
          )),
    );
  }
}
