import 'dart:convert';
import 'dart:math';

import 'package:KnowAI/data_provider/courses_provider.dart';
import 'package:KnowAI/model/course.dart';
import 'package:KnowAI/model/intro_questions.dart';
import 'package:KnowAI/model/lesson.dart';
import 'package:KnowAI/model/message.dart';
import 'package:KnowAI/model/quiz.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:uuid/uuid.dart';

class AIProvider {
  static Stream<OpenAIStreamChatCompletionModel>? generateResponse(
      Lesson lesson, List<Message> messages) {
    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
        role: OpenAIChatMessageRole.assistant,
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
              '''Sei un professore universitario di nome Kai, devi spiegare con chiarezza tutti i concetti che ti vengono chiesti

     '''),
        ]);
    try {
      final chatStream = OpenAI.instance.chat.createStream(
        model: "gpt-4o",
        seed: 6,
        messages: [
          if (lesson.completeText != null)
            OpenAIChatCompletionChoiceMessageModel(
                role: OpenAIChatMessageRole.assistant,
                content: [
                  OpenAIChatCompletionChoiceMessageContentItemModel.text(
                      lesson.completeText!),
                ]),
          systemMessage,
          for (Message m in messages)
            OpenAIChatCompletionChoiceMessageModel(
                role: m.isMine
                    ? OpenAIChatMessageRole.user
                    : OpenAIChatMessageRole.assistant,
                content: [
                  OpenAIChatCompletionChoiceMessageContentItemModel.text(
                      m.text),
                ]),
        ],
        temperature: 0.4,
        maxTokens: 3500,
      );

      return chatStream;
    } catch (e) {
      print(e);
    }
    return null;
    // Processa
  }

  static Future<Stream<OpenAIStreamChatCompletionModel>?> createLessonText(
      Lesson lesson, Course c) async {
    // the system message that will be sent to the request.
    List<Lesson>? lessons = await CoursesProvider.getLessons(c.id!);
    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
            '''Sei un professore universitario di nome Kai, devi spiegare con chiarezza tutti i concetti che ti vengono chiesti
           
     '''),
        for (Lesson l in (lessons ?? [])
            .where((element) => element.completeText != null)
            .toList())
          OpenAIChatCompletionChoiceMessageContentItemModel.text('''
  ${l.completeText}
''')
      ],
      role: OpenAIChatMessageRole.assistant,
    );

    // the user message that will be sent to the request.
    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          '''
Sto frequentando un corso online, questa è la lezione dal titolo: ${lesson.title}. Spiegami questo argomento in maniera precisa e dettagliata e meticolosa. In particolare devi coprire i seguenti argomenti: ${lesson.content} Inizia direttamente come se stessi scrivendo un libro riguardo l'argormento
        Utilizza una formattazione markdown e scrivi almeno 4000 parole con degli esempi pratici!,
          ''',
        ),
      ],
      role: OpenAIChatMessageRole.user,
    );
    try {
      final chatStream = OpenAI.instance.chat.createStream(
        model: "gpt-4o",
        seed: 6,
        messages: [systemMessage, userMessage],
        temperature: 0.4,
        maxTokens: 3500,
      );

      return chatStream;
    } catch (e) {
      print(e);
    }
    return null;
    // Processa la risposta
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
            '''Ogni messaggio che scrivi deve ritornare in una JSON del genere: 
            {
            "array": [
     {
     "question":"domanda",
     "answers":[ "Risposta1", "Risposta2", "Risposta3",...]
     }
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
          '''
Voglio creare un corso di formazione che mi permetta di coprire 
i seguenti aspetti: $text. 
Fammi 5 domande a risposta chiusa che ti permettano di capire a che livello di competenza sono 
su questi fattori in maniera da calibrare al meglio la formazione del mio corso.
Inoltre fammi 5 domande sugli argomenti che desidererei approfondire in particolare 
e la strutturazione delle lezioni. (Il corso deve essere testuale e successivamente verrà scritto da te quindi non parlare di corsi dal vivo o video)
          ''',
        ),
      ],
      role: OpenAIChatMessageRole.user,
    );

    OpenAIChatCompletionModel chatCompletion =
        await OpenAI.instance.chat.create(
      model: "gpt-4o",
      responseFormat: {"type": "json_object"}, //Migliu nenti forse
      seed: Random().nextInt(50),
      messages: [systemMessage, userMessage],
      temperature: 0.2,
      maxTokens: 3000,
    );
    // Processa la risposta
    String? responseContent =
        chatCompletion.choices.first.message.content!.first.text;

    // Deserializza la risposta JSON
    Map jsonResponse = json.decode(responseContent ?? "");
    if (jsonResponse.containsKey("array")) {
      List<IntroQuestion> questions = [];
      for (Map<String, dynamic> m in jsonResponse['array']) {
        questions.add(IntroQuestion.fromJson(m));
      }
      return questions;
    }
    return null;
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
            '''Ogni messaggio che scrivi deve ritornare in  JSON del genere: 
     {
     "id":  "genera id casuale",
     "category": "Tema del corso", 
     "title": "titolo", 
     "level" : "principiante", 
     "numberLessons": num, 
      "description": "descrizione in 300 parole del corso"
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
        Considera le seguenti risposte durante la creazione del corso: $answers
          ''',
        ),
      ],
      role: OpenAIChatMessageRole.user,
    );
    try {
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
      var jsonResponse = json.decode(responseContent ?? "");
      jsonResponse['id'] = const Uuid().v4();
      return Course.fromJson(
          jsonResponse is List ? jsonResponse[0] : jsonResponse);
    } catch (e) {
      print(e);
    }
    return null;
    // Deserializza la risposta JSON
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
     "content": "testo integrale della lezione (minimo 300 parole) con formattazinoe",
     "title": "titolo della lezione", 
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
      model: "gpt-3.5-turbo",
      //responseFormat: {"type": "json_object"}, //Migliu nenti forse
      seed: 6,
      messages: [systemMessage, userMessage],
      temperature: 0.2,
      maxTokens: 3000,
    );
    String? responseContent =
        chatCompletion.choices.first.message.content!.first.text!;
    print(responseContent);

    List jsonResponse = (json.decode(responseContent ?? "")['array']);
    return jsonResponse.map((e) => Lesson.fromJson(e)).toList();
  }
}
