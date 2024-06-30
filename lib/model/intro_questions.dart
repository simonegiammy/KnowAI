class IntroQuestion {
  String? question;
  List? answers;

  IntroQuestion({this.question, this.answers});

  IntroQuestion.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    answers = json['answers'];
  }
}
