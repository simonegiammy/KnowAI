import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:KnowAI/data_provider/auth_provider.dart';
import 'package:KnowAI/data_provider/firebase_service.dart';
import 'package:KnowAI/screens/home_screen.dart';
import 'package:KnowAI/style.dart';
import 'package:KnowAI/widgets/input_field.dart';
import 'package:KnowAI/widgets/primary_button.dart';
import 'package:flutter/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.black,
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 450,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 2, child: Container()),
                Text(
                  "Benvenuto in KnowAI",
                  style: AppStyle.title,
                ),
                Text(
                  "Inserisci le tue credenziali",
                  style: AppStyle.regular.copyWith(fontSize: 20),
                ),
                Expanded(child: Container()),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email",
                    style: AppStyle.regular,
                  ),
                ),
                InputField(controller: emailController, isEmail: true),
                const SizedBox(
                  height: 8,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password",
                    style: AppStyle.regular,
                  ),
                ),
                InputField(controller: passwordController, isPassword: true),
                const SizedBox(
                  height: 8,
                ),
                PrimaryButton(
                    isLoading: isLoading,
                    text: "Accedi",
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      User? u = await AuthenticationProvider
                          .signInWithEmailAndPassword(
                              emailController.text, passwordController.text);
                      setState(() {
                        isLoading = false;
                      });
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
        ),
      ),
    );
  }
}
