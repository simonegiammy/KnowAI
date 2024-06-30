import 'package:KnowAI/data_provider/ai_provider.dart';
import 'package:KnowAI/data_provider/storage_provider.dart';
import 'package:KnowAI/model/intro_questions.dart';
import 'package:KnowAI/screens/iintro_quiz_screen.dart';
import 'package:KnowAI/style.dart';
import 'package:KnowAI/widgets/button.dart';
import 'package:KnowAI/widgets/input_field.dart';
import 'package:KnowAI/widgets/primary_button.dart';
import 'package:KnowAI/widgets/retry_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewCourseScreen extends StatefulWidget {
  const NewCourseScreen({super.key});

  @override
  State<NewCourseScreen> createState() => _NewCourseScreenState();
}

class _NewCourseScreenState extends State<NewCourseScreen> {
  final textController = TextEditingController();
  bool isLoading = false;
  int value = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
              Text("Benvenuto nella procedura guidata di creazione corso!",
                  style: AppStyle.title.copyWith(height: 1.1, fontSize: 24)),
              const SizedBox(
                height: 12,
              ),
              Text("Cosa vorresti imparare? ",
                  style: AppStyle.title.copyWith(height: 1.1, fontSize: 20)),
              const SizedBox(
                height: 8,
              ),
              Text("Inserisci qui le competenze che vorresti acquisire: ",
                  style: AppStyle.regular.copyWith(
                      height: 1.1,
                      fontSize: 16,
                      color: const Color(0xff858585))),
              const SizedBox(
                height: 4,
              ),
              InputField(
                  iconPath: 'assets/icons/icon_insert.svg',
                  maxLines: 5,
                  controller: textController),
              const SizedBox(
                height: 12,
              ),
              Text(
                  "KnowAI ti farà qualche domande per capire meglio le tue esigenze e le tue attuali competenze. In questo modo il corso si adatterà perfettamente a te!",
                  style: AppStyle.regular.copyWith(height: 1.1, fontSize: 18)),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                  future: StorageProvider.getValue(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      value = snapshot.data!;
                    }
                    return Text(
                        "Hai  generato $value/5 corsi!\nPadron Giammy non caga denaro quindi sappi che c'è sto limite",
                        style: AppStyle.regular.copyWith(
                            height: 1.1,
                            fontSize: 16,
                            color: const Color(0xff858585)));
                  }),
              const SizedBox(
                height: 20,
              ),
              if (!isLoading && value < 5)
                SecondaryButton(
                    color: AppStyle.greenLight,
                    iconPath: "assets/icons/icon_generate.svg",
                    text: "Genera quiz introduttivo con KnowAI!",
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        List<IntroQuestion>? questions =
                            await AIProvider.generateQuestions(
                                textController.text);
                        if ((questions ?? []).isNotEmpty) {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return IntroQuestionsScreen(
                                domande: questions!,
                                topic: textController.text,
                              );
                            },
                          ));
                        }
                      } catch (e) {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return RetryDialog(
                              onTap: () {},
                            );
                          },
                        );
                      }
                      setState(() {
                        isLoading = false;
                      });
                    })
              else
                const Center(
                  child: CircularProgressIndicator(),
                )
            ],
          ),
        ),
      ),
    );
  }
}
