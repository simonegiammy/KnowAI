import 'package:KnowAI/model/quiz.dart';
import 'package:KnowAI/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class QuizTile extends StatelessWidget {
  final Quiz quiz;
  const QuizTile({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width * 0.3,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      decoration: const BoxDecoration(
          color: Color(0xff33363F),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                quiz.title!,
                style: AppStyle.title.copyWith(fontSize: 16, height: 1.1),
              ),
              Text(
                "📚 ${quiz.answers!.length} domande",
                style: AppStyle.semibold
                    .copyWith(fontSize: 14, color: const Color(0xff858585)),
              )
            ],
          ),
          const SizedBox(
            width: 12,
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: AppStyle.red,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: SvgPicture.asset('assets/icons/icon_play.svg'),
          )
        ],
      ),
    );
  }
}
