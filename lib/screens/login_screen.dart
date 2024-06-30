import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:KnowAI/data_provider/auth_provider.dart';
import 'package:KnowAI/data_provider/firebase_service.dart';
import 'package:KnowAI/screens/home_screen.dart';
import 'package:KnowAI/style.dart';
import 'package:KnowAI/widgets/input_field.dart';
import 'package:KnowAI/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    /*WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      User? u = await AuthenticationProvider.signInWithEmailAndPassword(
          "simone.giammusso@gmail.com", "ciaociao");
      if (u != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return const HomeScreen();
          },
        ));
      }
    });*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: Container()),
            Text(
              "Benvenuto in KnowAI",
              style: AppStyle.title,
            ),
            Text(
              "Inserisci le tue credenziali",
              style: AppStyle.semibold,
            ),
            Expanded(child: Container()),
            Text(
              "Email",
              style: AppStyle.regular,
            ),
            InputField(controller: emailController),
            Text(
              "Password",
              style: AppStyle.regular,
            ),
            InputField(controller: passwordController),
            const SizedBox(
              height: 8,
            ),
            PrimaryButton(
                text: "Accedi",
                onTap: () async {
                  User? u =
                      await AuthenticationProvider.signInWithEmailAndPassword(
                          emailController.text, passwordController.text);
                  if (u != null) {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return const HomeScreen();
                      },
                    ));
                  }
                }),
            Expanded(flex: 4, child: Container())
          ],
        ),
      ),
    );
  }
}
