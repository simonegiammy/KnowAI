import 'dart:convert';

import 'package:KnowAI/model/course.dart';
import 'package:KnowAI/model/intro_questions.dart';
import 'package:KnowAI/model/lesson.dart';
import 'package:KnowAI/model/quiz.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:uuid/uuid.dart';

class AIProvider {
  static Future<String?> createLessonText(Lesson lesson) async {
    // the system message that will be sent to the request.
    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
            '''Sei un professore universitario di nome Kai, devi spiegare con chiarezza tutti i concetti che ti vengono chiesti"
     }
     '''),
      ],
      role: OpenAIChatMessageRole.assistant,
    );

    // the user message that will be sent to the request.
    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          '''
Sto frequentando un corso online, questa è la lezione dal titolo: ${lesson.title}. Spiegami questo argomento in maniera precisa e dettagliata e meticolosa. In particolare devi coprire i seguenti argomenti: ${lesson.content} Inizia direttamente come se stessi scrivendo un libro riguardo l'argormento
         Devi scrivere almeno 4000 parole!
          ''',
        ),
      ],
      role: OpenAIChatMessageRole.user,
    );

    OpenAIChatCompletionModel chatCompletion =
        await OpenAI.instance.chat.create(
      model: "gpt-4-turbo",
      stop: null,
      // responseFormat: {"type": "json_object"}, //Migliu nenti forse
      seed: 6,
      messages: [systemMessage, userMessage],
      temperature: 0.4,
      maxTokens: 3500,
    );

    // Processa la risposta
    return chatCompletion.choices.first.message.content!.first.text;
  }

  static Future<String?> generatePreviewPhoto(String prompt) async {
    OpenAIImageModel image = await OpenAI.instance.image.create(
      prompt: prompt,
      n: 1,
      size: OpenAIImageSize.size1024,
      responseFormat: OpenAIImageResponseFormat.url,
    );

// Printing the output to the console.
    for (int index = 0; index < image.data.length; index++) {
      final currentItem = image.data[index];
      return (currentItem.url!);
    }
    return null;
  }

  static Future<List<IntroQuestion>?> generateQuestions(String text) async {
    // the system message that will be sent to the request.
    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
            '''Ogni messaggio che scrivi deve ritornare in una lista di JSON del genere: [
     {
     "question":"domanda",
     "answers":[ "Risposta1", "Risposta2", "Risposta3",...]
     }
     ]'''),
      ],
      role: OpenAIChatMessageRole.assistant,
    );

    // the user message that will be sent to the request.
    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          "Voglio creare un corso di formazione che mi permetta di coprire i seguenti aspetti: $text. Fammi 5 domande a risposta chiusa che ti permettano di capire a che livello di competenza sono su questi fattori in maniera da calibrare al meglio la formazione del mio corso",
        ),
      ],
      role: OpenAIChatMessageRole.user,
    );

    OpenAIChatCompletionModel chatCompletion =
        await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo",
      // responseFormat: {"type": "json_object"}, //Migliu nenti forse
      seed: 6,
      messages: [systemMessage, userMessage],
      temperature: 0.2,
      maxTokens: 1000,
    );
    // Processa la risposta
    String? responseContent =
        chatCompletion.choices.first.message.content!.first.text;

    // Deserializza la risposta JSON
    var jsonResponse = json.decode(responseContent ?? "");

    List<IntroQuestion> questions = [];
    for (Map<String, dynamic> m in jsonResponse) {
      questions.add(IntroQuestion.fromJson(m));
    }

    return questions;
  }

  static Future<Quiz?> generateQuiz(String text) async {
    // the system message that will be sent to the request.
    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
            '''Ogni messaggio che scrivi deve ritornare in un JSON del genere:
     {"id":${const Uuid().v4()},
     title: "titolo del quiz",
     questions:["Domanda1", "Domanda2",...]
     "answers":[{
     "risposta1": true,  //La risposta corretta deve essere true
     "risposta2": false, 
     "risposta3": false
     }]}  
     '''),
      ],
      role: OpenAIChatMessageRole.assistant,
    );

    // the user message that will be sent to the request.
    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
            "Genera 5 domande a risposta multipla che mi aiutino a capire se ho compreso i concetti della lezione $text"),
      ],
      role: OpenAIChatMessageRole.user,
    );

    OpenAIChatCompletionModel chatCompletion =
        await OpenAI.instance.chat.create(
      model: "gpt-4o",
      responseFormat: {"type": "json_object"}, //Migliu nenti forse
      seed: 6,
      messages: [systemMessage, userMessage],
      temperature: 0.2,
      maxTokens: 3000,
    );
    // Processa la risposta
    String? responseContent =
        chatCompletion.choices.first.message.content!.first.text;

    // Deserializza la risposta JSON
    var jsonResponse = json.decode(responseContent ?? "");

    return Quiz.fromJson(jsonResponse);
  }

  static Future<Course?> createCourse(String topic, String answers) async {
    // the system message that will be sent to the request.
    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
            '''Ogni messaggio che scrivi deve ritornare in una lista di JSON del genere: 
     {
     "id":  "genera id casuale",
     "category": "Tema del corso", 
     "title": "titolo", 
     "level" : "principiante", 
     "numberLessons": num, 
      "description": "descrizione in 300 caratteri del corso"
     }
     '''),
      ],
      role: OpenAIChatMessageRole.assistant,
    );

    // the user message that will be sent to the request.
    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          '''Voglio creare un corso di formazione che mi permetta di apprendere i seguenti aspetti: $topic. 
        Crea un piano di apprendimento personalizzato per permettermi di 
        imparare i temi e le skills necessarie per capire al meglio $topic.  
          ''',
        ),
      ],
      role: OpenAIChatMessageRole.user,
    );

    OpenAIChatCompletionModel chatCompletion =
        await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo",
      // responseFormat: {"type": "json_object"}, //Migliu nenti forse
      seed: 6,
      messages: [systemMessage, userMessage],
      temperature: 0.2,
      maxTokens: 1000,
    );
    // Processa la risposta
    String? responseContent =
        chatCompletion.choices.first.message.content!.first.text;

    // Deserializza la risposta JSON
    var jsonResponse = json.decode(responseContent ?? "");
    jsonResponse['id'] = const Uuid().v4();
    return Course.fromJson(
        jsonResponse is List ? jsonResponse[0] : jsonResponse);
  }

  static Future<List<Lesson>?> generateLessons(
      String description, String answers, int number) async {
    // the system message that will be sent to the request.
    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
            '''Ogni messaggio che scrivi deve ritornare in una lista di JSON del genere: 
     {
     array: [
     {
    "id": 1//in ordine crescente di lezione,
     "content": "testo integrale della lezione (minimo 1000 parole) con formattazinoe",
     "title": "titolo della lezione", 
     "relatedLinks": ["link youtube italia per video utile", ...]
     },
     {...},
      ]
     }
     '''),
      ],
      role: OpenAIChatMessageRole.assistant,
    );
    // the user message that will be sent to the request.
    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          '''Voglio creare un corso di formazione che mi permetta di apprendere i seguenti aspetti: $description 
        Crea un piano di apprendimento personalizzato di $number lezioni per permettermi di 
        imparare i temi e le skills necessarie. Ho fatto un quiz introduttivo per stimare le mie capacità, ti lascio le risposte, 
        calibra il contenuto e la forma delle lezioni in base alle mie competenze dedotte da queste risposte: $answers 
          ''',
        ),
      ],
      role: OpenAIChatMessageRole.user,
    );

    OpenAIChatCompletionModel chatCompletion =
        await OpenAI.instance.chat.create(
      model: "gpt-4o",
      responseFormat: {"type": "json_object"}, //Migliu nenti forse
      seed: 6,
      messages: [systemMessage, userMessage],
      temperature: 0.2,
      maxTokens: 2000,
    );

    String? responseContent =
        chatCompletion.choices.first.message.content!.first.text!;
    List jsonResponse = (json.decode(responseContent ?? "")['array']);
    return jsonResponse.map((e) => Lesson.fromJson(e)).toList();
  }
}
