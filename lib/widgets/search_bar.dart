import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_app/style.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 8),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/icon_search.svg',
            width: 30,
            height: 30,
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
              child: TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Cerca il corso che fa per te...",
                hintStyle: AppStyle.light),
          ))
        ],
      ),
    );
  }
}