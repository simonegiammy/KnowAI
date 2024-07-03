import 'dart:convert';

import 'package:KnowAI/data_provider/auth_provider.dart';
import 'package:KnowAI/data_provider/courses_provider.dart';
import 'package:KnowAI/model/course.dart';
import 'package:KnowAI/screens/course_screen.dart';
import 'package:KnowAI/screens/create_new_course.dart';
import 'package:KnowAI/screens/saved_courses_screen.dart';
import 'package:KnowAI/style.dart';
import 'package:KnowAI/widgets/button.dart';
import 'package:KnowAI/widgets/cookie.dart';
import 'package:KnowAI/widgets/course_tile.dart';
import 'package:KnowAI/widgets/search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> categories = [];
  String selectedCategory = "";
  List<Course>? courses;
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  @override
  void initState() {
    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        isSearching = false;
      } else {
        isSearching = true;
      }
      if (mounted) {
        setState(() {});
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      categories = await CoursesProvider.getCategories() ?? [];
      selectedCategory = categories[0] ?? "";
      courses = await CoursesProvider.getCourses("tutorial_titles");
      if (AuthenticationProvider.getCurrentUser()?.displayName == null) {
        await AuthenticationProvider.getCurrentUser()
            ?.updateDisplayName("Simone");
      }
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return Scaffold(
        backgroundColor: AppStyle.black,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: "Ciao ",
                            style: AppStyle.regular.copyWith(
                              fontSize: 30,
                            )),
                        TextSpan(
                            text:
                                "${AuthenticationProvider.getCurrentUser()!.displayName}!",
                            style: AppStyle.title.copyWith(
                              fontSize: 30,
                            ))
                      ])),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    AppButton(
                        iconPath: "assets/icons/icon_bookmark.svg",
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const SavedCoursesScreen();
                            },
                          ));
                        })
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    categories = await CoursesProvider.getCategories() ?? [];
                    selectedCategory = categories[0];
                    courses =
                        await CoursesProvider.getCourses("tutorial_titles");
                    setState(() {});
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const NewCourseScreen();
                              },
                            ));
                          },
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 450),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppStyle.gray,
                                ),
                                color: AppStyle.greenDark.withOpacity(0.3),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppButton(
                                    iconPath: "assets/icons/icon_add.svg",
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return const NewCourseScreen();
                                        },
                                      ));
                                    }),
                                Container(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Genera il tuo corso con KAI!",
                                        style: AppStyle.semibold
                                            .copyWith(height: 1.2),
                                      ),
                                      Text(
                                        "Rispondi a poche domande e comincia a imparare!",
                                        style: AppStyle.light,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 16,
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: AppSearchBar(
                              controller: searchController,
                            ),
                          ),
                        ),
                        if (!isSearching) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            child: Text(
                              "Categorie:",
                              style: AppStyle.semibold.copyWith(fontSize: 24),
                            ),
                          ),
                          Container(
                            height: 35,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            child: ListView(
                              padding: const EdgeInsets.only(left: 20),
                              scrollDirection: Axis.horizontal,
                              children: [
                                for (String s in categories)
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedCategory = s;
                                        });
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 6),
                                        child: CookieTile(
                                            text: s,
                                            selected: s == selectedCategory),
                                      ))
                              ],
                            ),
                          ),
                        ],
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Wrap(
                                  runSpacing: 8,
                                  spacing: 8,
                                  children: isSearching
                                      ? [
                                          for (Course c in (courses?.where(
                                                  (element) => (element.title ??
                                                          "")
                                                      .toString()
                                                      .toLowerCase()
                                                      .contains(searchController
                                                          .text
                                                          .toLowerCase()))) ??
                                              [])
                                            GestureDetector(
                                                onTap: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                    builder: (context) {
                                                      return CourseScreen(
                                                          course: c);
                                                    },
                                                  ));
                                                },
                                                child: CourseTile(course: c))
                                        ]
                                      : [
                                          if ((courses?.where((element) =>
                                                      element.category ==
                                                      selectedCategory) ??
                                                  [])
                                              .isEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 24),
                                              child: Text(
                                                "Non ci sono corsi disponibili per questa categoria",
                                                style: AppStyle.semibold,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          for (Course c in courses?.where(
                                                  (element) =>
                                                      element.category ==
                                                      selectedCategory) ??
                                              [])
                                            GestureDetector(
                                                onTap: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                    builder: (contex) {
                                                      return CourseScreen(
                                                          course: c);
                                                    },
                                                  ));
                                                },
                                                child: CourseTile(course: c))
                                        ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
