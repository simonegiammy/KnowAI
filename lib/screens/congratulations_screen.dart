import 'package:KnowAI/style.dart';
import 'package:KnowAI/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class CongratulationScreen extends StatefulWidget {
  final int n;
  final int total;
  const CongratulationScreen({super.key, required this.n, required this.total});

  @override
  State<CongratulationScreen> createState() => _CongratulationScreenState();
}

class _CongratulationScreenState extends State<CongratulationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.black,
      body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Text(
                "Hai risposto correttamente a ${widget.n} domande su ${widget.total}",
                style: AppStyle.semibold,
              ),
              PrimaryButton(
                  text: "Torna alla home",
                  onTap: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  })
            ],
          )),
    );
  }
}
