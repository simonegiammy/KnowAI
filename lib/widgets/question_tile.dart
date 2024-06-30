import 'package:KnowAI/style.dart';
import 'package:flutter/material.dart';

class ProgressBarQuestion extends StatefulWidget {
  final int currentQuestion;
  final int totalQuestions;
  const ProgressBarQuestion(
      {super.key, required this.currentQuestion, required this.totalQuestions});

  @override
  State<ProgressBarQuestion> createState() => _ProgressBarQuestionState();
}

class _ProgressBarQuestionState extends State<ProgressBarQuestion> {
  double width = 0;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: 5,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: const BorderRadius.all(Radius.circular(70))),
      child: Row(
        children: [
          Container(
            width: (width / widget.totalQuestions) * (widget.currentQuestion),
            color: AppStyle.greenDark,
          ),
        ],
      ),
    );
  }
}

class QuestionTile extends StatefulWidget {
  bool selected;
  bool confirmed;
  final Function() onTap;
  final String text;
  QuestionTile(
      {super.key,
      required this.confirmed,
      required this.selected,
      required this.onTap,
      required this.text});

  @override
  State<QuestionTile> createState() => _QuestionTileState();
}

class _QuestionTileState extends State<QuestionTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          widget.selected = true;
        });
      },
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          shadows: const [],
          color: widget.confirmed
              ? const Color(0XFF00A239).withOpacity(0.1)
              : widget.selected
                  ? AppStyle.gray.withOpacity(0.3)
                  : const Color(0xff2A2D32),
          shape: RoundedRectangleBorder(
            side: BorderSide(
                strokeAlign: BorderSide.strokeAlignInside,
                width: 1,
                color: widget.confirmed
                    ? AppStyle.black
                    : widget.selected
                        ? const Color(0xffa9a9a9)
                        : const Color(0x0ff85858)),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: 1,
                      color: widget.confirmed
                          ? const Color(0XFF00A239)
                          : widget.selected
                              ? const Color(0xFFA9A9A9)
                              : const Color(0xfff0f0f0))),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.confirmed
                        ? const Color(0XFF00A239)
                        : widget.selected
                            ? null
                            : Colors.white),
              ),
            ),
            Expanded(
              child: Text(widget.text,
                  style: AppStyle.regular.copyWith(
                      fontSize: 16,
                      color: widget.confirmed ? Colors.white : Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
