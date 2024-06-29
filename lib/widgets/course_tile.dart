import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_app/model/course.dart';
import 'package:news_app/style.dart';

class CourseTile extends StatelessWidget {
  Course course;
  CourseTile({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          color: AppStyle.gray),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.category!,
                  style: AppStyle.regular
                      .copyWith(color: const Color(0xff858585), fontSize: 16),
                ),
                Text(
                  course.title!,
                  style: AppStyle.semibold.copyWith(fontSize: 24, height: 1),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/icon_star.svg'),
                    Text(
                      "4.8",
                      style: AppStyle.semibold.copyWith(fontSize: 16),
                    ),
                    Text(
                      "  (2000 recensioni)",
                      style: AppStyle.light.copyWith(fontSize: 16),
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            width: 90,
            height: 90,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: AppStyle.greenDark.withOpacity(0.3),
                border:
                    Border.all(color: const Color(0xfff0f0f0).withOpacity(0.3)),
                borderRadius: const BorderRadius.all(Radius.circular(12))),
            child: Image.network(course.imageUrl!),
          )
        ],
      ),
    );
  }
}
