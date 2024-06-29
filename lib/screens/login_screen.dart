import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/data_provider/auth_provider.dart';
import 'package:news_app/data_provider/firebase_service.dart';
import 'package:news_app/screens/home_screen.dart';
import 'package:news_app/style.dart';
import 'package:news_app/widgets/input_field.dart';
import 'package:news_app/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const HomeScreen();
                      },
                    ));
                  }
                }),
            Expanded(child: Container())
          ],
        ),
      ),
    );
  }
}
