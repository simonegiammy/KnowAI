import 'package:KnowAI/model/intro_questions.dart';
import 'package:KnowAI/screens/preview_course_screen.dart';
import 'package:KnowAI/style.dart';
import 'package:KnowAI/widgets/back_button.dart';
import 'package:KnowAI/widgets/question_tile.dart';
import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

class IntroQuestionsScreen extends StatefulWidget {
  List<IntroQuestion> domande;
  String topic;
  IntroQuestionsScreen({super.key, required this.domande, required this.topic});

  @override
  State<IntroQuestionsScreen> createState() => _IntroQuestionsScreenState();
}

class _IntroQuestionsScreenState extends State<IntroQuestionsScreen> {
  int currentQuestion = 0; //Avoiding welcome screen
  List<IntroQuestion> domande = [];
  List<int> risposte = [];
  bool isLoading = false;
  bool isConfirmed = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      domande = widget.domande;
      for (IntroQuestion mq in domande) {
        risposte.add(-1);
      }
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (domande.isNotEmpty) {
      return Scaffold(
        backgroundColor: AppStyle.black,
        body: SafeArea(
          bottom: false,
          child: SizedBox.expand(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Domanda",
                    style: AppStyle.regular
                        .copyWith(color: AppStyle.gray, fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "${currentQuestion + 1}",
                        style: AppStyle.semibold
                            .copyWith(color: AppStyle.greenDark, fontSize: 24)),
                    TextSpan(
                        text: "/${domande.length}",
                        style: AppStyle.regular.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 24))
                  ])),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ProgressBarQuestion(
                    currentQuestion: currentQuestion + 1,
                    totalQuestions: domande.length,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    domande[currentQuestion].question ?? "",
                    textAlign: TextAlign.center,
                    style: AppStyle.semibold.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                      color: AppStyle.greenLight.withOpacity(0.65),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16))),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 12, 0, 0),
                            child: GestureDetector(
                              onTap: () {
                                if (currentQuestion > 1) {
                                  setState(() {
                                    currentQuestion--;
                                  });
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                              child: const AppBackButton(),
                            ),
                          ),
                        ],
                      ),
                      for (int i = 0;
                          i < domande[currentQuestion].answers!.length;
                          i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 0),
                          child: QuestionTile(
                              confirmed:
                                  isConfirmed && i == risposte[currentQuestion],
                              selected: i == risposte[currentQuestion],
                              onTap: () {
                                Haptics.vibrate(HapticsType.selection);
                                setState(() {
                                  risposte[currentQuestion] = i;
                                });
                                setState(() {
                                  isConfirmed = true;
                                });

                                Future.delayed(
                                    const Duration(milliseconds: 200), () {
                                  if (currentQuestion + 1 != domande.length) {
                                    setState(() {
                                      currentQuestion++;
                                    });
                                  } else {
                                    String res = "";
                                    for (IntroQuestion q in domande) {
                                      res += "${q.question} ";
                                      res +=
                                          "${q.answers![risposte[domande.indexOf(q)]]}---";
                                    }

                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return PreviewCourseScreen(
                                            answers: res, topic: widget.topic);
                                      },
                                    ));
                                  }
                                });
                              },
                              text: domande[currentQuestion].answers![i]),
                        ),
                      Expanded(child: Container()),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      );
    }
    return Container();
  }
}
