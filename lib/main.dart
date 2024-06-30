import 'package:KnowAI/style.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:KnowAI/firebase_options.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:KnowAI/screens/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  //await dotenv.load(fileName: ".env");
  //OpenAI.apiKey = dotenv.env['OPENAI_KEY']!;
  OpenAI.apiKey = "sk-proj-mCNZX3pysIMaaMrQuqfhT3BlbkFJuPoIEPRaF8fkklbliG1h";
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppStyle.greenDark),
          useMaterial3: true,
        ),
        home: const LoginScreen());
  }
}
