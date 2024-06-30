import 'package:KnowAI/style.dart';
import 'package:KnowAI/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class RetryDialog extends StatelessWidget {
  final Function() onTap;
  const RetryDialog({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 36, vertical: 350),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.8,
        maxHeight: MediaQuery.of(context).size.width * 0.8,
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: AppStyle.black),
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            Text(
              "Si è verificato un errore, riprova più tardi",
              style: AppStyle.semibold.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            Expanded(child: Container()),
            PrimaryButton(
                text: "Chiudi e riprova",
                onTap: () {
                  onTap();
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }
}
