import 'package:flutter/material.dart';

class AppStyle {
  static Color greenLight = const Color(0xff3E7856);
  static Color greenDark = const Color(0xff39594B);
  static Color red = const Color(0xffF54768);
  static Color gray = const Color(0xff858585).withOpacity(0.3);
  static Color black = const Color(0xff1C1C1C);

  static TextStyle regular = const TextStyle(
      fontFamily: "SFProText",
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 14);
  static TextStyle light = const TextStyle(
      fontFamily: "SFProText",
      color: Color(0xff858585),
      fontWeight: FontWeight.w500,
      fontSize: 16);
  static TextStyle semibold = const TextStyle(
      fontFamily: "SFProText",
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 20);
  static TextStyle title = const TextStyle(
      fontFamily: "SFProText",
      color: Colors.white,
      fontWeight: FontWeight.w700,
      fontSize: 30);
}
