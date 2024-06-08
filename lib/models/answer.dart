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
  String? question;
  bool? answer;
  Answers({this.question, this.answer});

 

  Answers.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question'] = question;
    data['answer'] = answer;
    return data;
  }

   Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
    };
  }
}