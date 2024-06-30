class Quiz {
  String? id;
  String? title;
  List<Map<String, dynamic>>? answers;
  List<String>? questions;

  Quiz({this.id, this.title, this.answers, this.questions});

  Quiz.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    answers = (json['answers'] as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
    questions = json['questions'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['answers'] = answers;
    data['questions'] = questions;
    return data;
  }
}
