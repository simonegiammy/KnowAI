import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
                          text: "Simone!",
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
                            const AppSearchBar()
                          ],
                        ),
                      ),
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
                                      text: s, selected: s == selectedCategory))
                          ],
                        ),
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Column(
                          children: [
                            CourseTile(),
                            SizedBox(
                              height: 8,
                            ),
                            CourseTile(),
                            SizedBox(
                              height: 8,
                            ),
                            CourseTile()
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
