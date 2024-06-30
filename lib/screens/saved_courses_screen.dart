import 'package:KnowAI/data_provider/courses_provider.dart';
import 'package:KnowAI/model/course.dart';
import 'package:KnowAI/screens/course_screen.dart';
import 'package:KnowAI/style.dart';
import 'package:KnowAI/widgets/button.dart';
import 'package:KnowAI/widgets/course_tile.dart';
import 'package:flutter/material.dart';

class SavedCoursesScreen extends StatefulWidget {
  const SavedCoursesScreen({super.key});

  @override
  State<SavedCoursesScreen> createState() => _SavedCoursesScreenState();
}

class _SavedCoursesScreenState extends State<SavedCoursesScreen> {
  List<Course>? savedCourses = [];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      savedCourses = await CoursesProvider.getSavedCourses();
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
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                for (Course c in savedCourses ?? [])
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return CourseScreen(course: c);
                              },
                            ));
                          },
                          child: CourseTile(course: c)))
              ],
            ),
          )),
    );
  }
}
