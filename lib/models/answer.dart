class Answer {
  String? question;
  bool? answer;
  Answer({this.question, this.answer});

  factory Answer.fromMap(Map<String, dynamic> map) {
    return Answer(
      question: map["question"],
      answer: map["answer"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
    };
  }
}

class Answers {
  String? _question;
  bool? _answer;

  Answers({String? question, bool? answer}) {
    if (question != null) {
      _question = question;
    }
    if (answer != null) {
      _answer = answer;
    }
  }

  String? get question => _question;
  set question(String? question) => _question = question;
  bool? get answer => _answer;
  set answer(bool? answer) => _answer = answer;

  Answers.fromJson(Map<String, dynamic> json) {
    _question = json['question'];
    _answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question'] = _question;
    data['answer'] = _answer;
    return data;
  }

   Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
    };
  }
}