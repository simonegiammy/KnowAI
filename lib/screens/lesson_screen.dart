import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:KnowAI/data_provider/ai_provider.dart';
import 'package:KnowAI/data_provider/courses_provider.dart';
import 'package:KnowAI/model/course.dart';
import 'package:KnowAI/model/lesson.dart';
import 'package:KnowAI/model/message.dart';
import 'package:KnowAI/model/quiz.dart';
import 'package:KnowAI/screens/quiz_screen.dart';
import 'package:KnowAI/style.dart';
import 'package:KnowAI/widgets/button.dart';
import 'package:KnowAI/widgets/fab.dart';
import 'package:KnowAI/widgets/input_field.dart';
import 'package:KnowAI/widgets/primary_button.dart';
import 'package:KnowAI/widgets/quiz_tile.dart';
import 'package:KnowAI/widgets/retry_dialog.dart';
import 'package:KnowAI/widgets/youtube_preview.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';

class LessonScreen extends StatefulWidget {
  final Lesson lesson;
  final Course c;
  const LessonScreen({super.key, required this.lesson, required this.c});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  bool isLoading = false;
  bool isLoadingQuiz = false;
  bool showingChat = false;
  List<Message> messages = [];
  bool isCompleted = false;
  bool isScrolled = false;
  String finishReason = "";
  ScrollController scrollController = ScrollController();
  StreamSubscription<OpenAIStreamChatCompletionModel>? _subscription;
  TextEditingController textController = TextEditingController();
  @override
  void initState() {
    scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.lesson.completeText == null) {
        setState(() {
          isLoading = true;
        });
        try {
          Stream<OpenAIStreamChatCompletionModel>? chatStream =
              await AIProvider.createLessonText(widget.lesson, widget.c);
          // Listen to the stream.
          _subscription = chatStream!.listen(
            (streamChatCompletion) {
              final content = streamChatCompletion.choices.first.delta.content;
              if (content?.first?.text != null) {
                setState(() {
                  widget.lesson.completeText ??= "";

                  widget.lesson.completeText =
                      widget.lesson.completeText! + content!.first!.text!;
                  if (streamChatCompletion.choices.first.finishReason != null) {
                    finishReason =
                        streamChatCompletion.choices.first.finishReason!;
                  }
                });
              }
            },
            onDone: () async {
              setState(() {
                CoursesProvider.updateLesson(widget.lesson, widget.c.id!);
                isLoading = false;
              });
              return;
            },
          );
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
      }
      isCompleted = await CoursesProvider.isCompleted(
              "${widget.lesson.id!}", widget.c.id!) ??
          false;
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  void _scrollListener() {
    if (scrollController.offset != scrollController.initialScrollOffset) {
      setState(() {
        isScrolled = true;
      });
    } else {
      setState(() {
        isScrolled = false;
      });
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    _subscription?.cancel();
    super.dispose();
  }

  onSubmit() async {
    setState(() {
      messages.add(Message(
          id: Random().nextInt(120).toString(),
          text: textController.text,
          isMine: true));
    });
    textController.clear();
    String rand = Random().nextInt(120).toString();
    setState(() {
      messages.add(Message(id: rand, text: "", isMine: false));
    });
    String text = "";
    StreamSubscription<OpenAIStreamChatCompletionModel>? subscription2;
    Stream<OpenAIStreamChatCompletionModel>? chatStream =
        AIProvider.generateResponse(widget.lesson, messages);
    // Listen to the stream.
    if (chatStream != null) {
      subscription2 = chatStream.listen((streamChatCompletion) {
        final content = streamChatCompletion.choices.first.delta.content;
        if (content?.first?.text != null) {
          setState(() {
            text += content!.first!.text!;
            for (Message m in messages) {
              if (m.id == rand) {
                m.text = text;
              }
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lesson.completeText == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    buildChat() {
      return Container(
        padding: const EdgeInsets.only(
          left: 16,
        ),
        margin: const EdgeInsets.only(left: 16, top: 64, bottom: 64),
        decoration: BoxDecoration(
            border: Border(left: BorderSide(color: AppStyle.gray))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Chiedi a Kai! ",
              style: AppStyle.title.copyWith(fontSize: 24),
            ),
            Text(
              "Seleziona il testo che non ti è chiaro e comincia la chat!",
              style: AppStyle.regular
                  .copyWith(fontSize: 18, color: const Color(0xff858585)),
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (Message m in messages)
                      Align(
                        alignment: m.isMine
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          child: Markdown(
                            physics: const NeverScrollableScrollPhysics(),
                            data: m.text,
                            shrinkWrap: true,
                            styleSheet: MarkdownStyleSheet(
                                codeblockDecoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    color: const Color(0xfff6f6f6)
                                        .withOpacity(0.1)),
                                code: const TextStyle(
                                    backgroundColor: Colors.transparent,
                                    decorationColor: Colors.transparent,
                                    decoration: TextDecoration.none,
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'SFPro-Text'),
                                h1: AppStyle.title
                                    .copyWith(color: AppStyle.greenLight),
                                p: AppStyle.regular.copyWith(
                                    fontSize: 18,
                                    color: m.isMine
                                        ? const Color(0xff858585)
                                        : const Color(0xfff0f0f0)
                                            .withOpacity(0.8))),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            )),
            Row(
              children: [
                Expanded(
                  child: InputField(
                    maxLines: 6,
                    onSumbit: () {
                      onSubmit();
                    },
                    controller: textController,
                    //iconPath: "assets/icons/icon_send.svg",
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                AppButton(
                  iconPath: "assets/icons/icon_send.svg",
                  onTap: () {
                    onSubmit();
                  },
                )
              ],
            )
          ],
        ),
      );
    }

    return Scaffold(
      floatingActionButton: isScrolled ||
              (showingChat && MediaQuery.of(context).size.width <= 500)
          ? AppFab(
              onTap: showingChat
                  ? () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return Container(
                              color: AppStyle.black,
                              constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.9,
                                  maxWidth: MediaQuery.of(context).size.width),
                              child: buildChat());
                        },
                      );
                    }
                  : () {
                      scrollController.jumpTo(0);
                    },
              iconPath: showingChat
                  ? 'assets/icons/icon_send.svg'
                  : 'assets/icons/icon_back.svg')
          : null,
      backgroundColor: AppStyle.black,
      body: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1500),
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
                            style: AppStyle.regular.copyWith(
                                color: const Color(0xff858585), fontSize: 16),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            "${widget.lesson.title}",
                            style: AppStyle.title
                                .copyWith(fontSize: 24, height: 1.1),
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
                                h1: AppStyle.title
                                    .copyWith(color: AppStyle.greenDark),
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
                          if (widget.lesson.completeText != null)
                            Markdown(
                              onSelectionChanged: (text, selection, cause) {
                                if (selection.textInside(text ?? "").length >
                                        5 &&
                                    cause == SelectionChangedCause.drag) {
                                  textController.text =
                                      selection.textInside(text ?? "");
                                  setState(() {
                                    showingChat = true;
                                  });
                                } else {
                                  setState(() {
                                    showingChat = false;
                                  });
                                }
                              },
                              selectable: true,
                              data: widget.lesson.completeText!,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(),
                              shrinkWrap: true,
                              styleSheet: MarkdownStyleSheet(
                                  codeblockDecoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      color: const Color(0xfff6f6f6)
                                          .withOpacity(0.1)),
                                  code: const TextStyle(
                                      backgroundColor: Colors.transparent,
                                      decorationColor: Colors.transparent,
                                      decoration: TextDecoration.none,
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'SFPro-Text'),
                                  h1: AppStyle.title
                                      .copyWith(color: AppStyle.greenLight),
                                  p: AppStyle.regular.copyWith(
                                      fontSize: 18,
                                      color: const Color(0xfff0f0f0)
                                          .withOpacity(0.8))),
                              //style: AppStyle.regular.copyWith(fontSize: 18),
                            ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            "🙋🏻‍♂️ E’ tempo di quiz",
                            style: AppStyle.title
                                .copyWith(fontSize: 18, height: 1.1),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                              builder: (context) {
                                                return QuizScreen(
                                                  quiz: q,
                                                );
                                              },
                                            ));
                                          },
                                          child: QuizTile(quiz: q))),
                                isLoadingQuiz
                                    ? const CircularProgressIndicator()
                                    : AppButton(
                                        iconPath: "assets/icons/icon_add.svg",
                                        onTap: () async {
                                          setState(() {
                                            isLoadingQuiz = true;
                                          });
                                          Quiz? q =
                                              await AIProvider.generateQuiz(
                                                  widget.lesson.completeText ??
                                                      widget.lesson.content!);
                                          if (q != null) {
                                            Lesson l = widget.lesson;
                                            (l.quizes ?? []).add(q);
                                            setState(() {
                                              isLoadingQuiz = false;
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
                                    color: const Color(0xff858585),
                                    fontSize: 16),
                              ),
                            ),
                          SizedBox(
                            height: 160,
                            width: MediaQuery.of(context).size.width,
                            child: ListView(
                              padding: const EdgeInsets.only(top: 8),
                              scrollDirection: Axis.horizontal,
                              children: [
                                for (String s
                                    in widget.lesson.relatedLinks ?? [])
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
                                    await CoursesProvider
                                        .addOrRemoveCompletedLesson(
                                            "${widget.lesson.id!}",
                                            widget.c.id!);
                                    setState(() {
                                      isCompleted = !isCompleted;
                                    });
                                  }),
                            )
                        ],
                      ),
                    ),
                  ),
                ),
                if (MediaQuery.of(context).size.width > 500)
                  Expanded(flex: 2, child: buildChat())
              ],
            ),
          )),
    );
  }
}
