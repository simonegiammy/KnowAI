import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:news_app/data_provider/auth_provider.dart';
import 'package:news_app/data_provider/courses_provider.dart';
import 'package:news_app/model/course.dart';
import 'package:news_app/style.dart';
import 'package:news_app/widgets/button.dart';
import 'package:news_app/widgets/cookie.dart';
import 'package:news_app/widgets/course_tile.dart';
import 'package:news_app/widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> categories = [
    "Tech",
    "Programmazione",
    "Grafica",
    "Copywriting"
  ];
  String selectedCategory = "Tech";
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
      courses = await CoursesProvider.getData("tutorial_titles");
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
                    RichText(
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
                    AppButton(
                        iconPath: "assets/icons/icon_sort.svg", onTap: () {})
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 20),
                        decoration: BoxDecoration(
                            color: AppStyle.greenLight,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16))),
                        child: Column(
                          children: [
                            Text(
                              "Impara quello che vuoi, quando vuoi!",
                              style: AppStyle.title.copyWith(height: 1.2),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            AppSearchBar(
                              controller: searchController,
                            )
                          ],
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 0),
                          child: Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: [
                              for (String s in categories)
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedCategory = s;
                                      });
                                    },
                                    child: CookieTile(
                                        text: s,
                                        selected: s == selectedCategory))
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
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Column(
                                children: isSearching
                                    ? [
                                        for (Course c in (courses?.where(
                                                (element) => element.title!
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains(searchController
                                                        .text
                                                        .toLowerCase()))) ??
                                            [])
                                          CourseTile(course: c)
                                      ]
                                    : [
                                        if ((courses?.where((element) =>
                                                    element.category ==
                                                    selectedCategory) ??
                                                [])
                                            .isEmpty)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 24),
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
                                          CourseTile(course: c)
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
            ],
          ),
        ));
  }
}
