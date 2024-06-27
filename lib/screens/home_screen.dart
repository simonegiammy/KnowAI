import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return const Scaffold(
      body: Center(
        child: Text(
          "CIAONE",
          style: TextStyle(fontFamily: 'SF'),
        ),
      ),
    );
  }
}
