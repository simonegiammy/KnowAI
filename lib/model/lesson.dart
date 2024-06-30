import 'package:KnowAI/model/quiz.dart';

class Lesson {
  int? id;
  String? content;
  String? completeText;
  String? title;
  List<String>? relatedLinks;
  List<Quiz>? quizes;
  Lesson(
      {this.id,
      this.content,
      this.title,
      this.relatedLinks,
      this.quizes,
      this.completeText});

  Lesson.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    title = json['title'];
    var l = (json['quizes'] ?? []).map((e) => Quiz.fromJson(e)).toList();
    quizes = l.cast<Quiz>();
    if (json['relatedLinks'] != null) {
      relatedLinks = json['relatedLinks'].cast<String>();
    }
    completeText = json['completeText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['title'] = title;
    data['relatedLinks'] = relatedLinks;
    data['completeText'] = completeText;
    data['quizes'] = quizes?.map((e) => e.toJson());
    return data;
  }
}
