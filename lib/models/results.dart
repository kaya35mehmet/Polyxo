import 'package:buga/models/answer.dart';

class Results {
  String? page;
  String? guid;
  String? rivalguid;
  String? remainingtime;
  List<Answers>? answers;

  Results({
    this.page,
    this.guid,
    this.rivalguid,
    this.remainingtime,
    this.answers,
  });

  Results.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    guid = json['guid'];
    rivalguid = json['rivalguid'];
    remainingtime = json['remainingtime'];
    if (json['answers'] != null) {
      answers = <Answers>[];
      json['answers'].forEach((v) {
        answers!.add(Answers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['guid'] = guid;
    data['rivalguid'] = rivalguid;
    data['remainingtime'] = remainingtime;
    if (answers != null) {
      data['answers'] = answers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


