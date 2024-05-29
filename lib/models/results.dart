import 'package:Buga/models/answer.dart';

class Results {
  String? _page;
  String? _guid;
  String? _rivalguid;
  String? _remainingtime;
  List<Answers>? _answers;

  Results(
      {String? page,
      String? guid,
      String? rivalguid,
      String? remainingtime,
      List<Answers>? answers}) {
    if (page != null) {
      _page = page;
    }
    if (guid != null) {
      _guid = guid;
    }
    if (rivalguid != null) {
      _rivalguid = rivalguid;
    }
    if (remainingtime != null) {
      _remainingtime = remainingtime;
    }
    if (answers != null) {
      _answers = answers;
    }
  }

  String? get page => _page;
  set page(String? page) => _page = page;
  String? get guid => _guid;
  set guid(String? guid) => _guid = guid;
  String? get rivalguid => _rivalguid;
  set rivalguid(String? rivalguid) => _rivalguid = rivalguid;
  String? get remainingtime => _remainingtime;
  set remainingtime(String? remainingtime) => _remainingtime = remainingtime;
  List<Answers>? get answers => _answers;
  set answers(List<Answers>? answers) => _answers = answers;

  Results.fromJson(Map<String, dynamic> json) {
    _page = json['page'];
    _guid = json['guid'];
    _rivalguid = json['rivalguid'];
    _remainingtime = json['remainingtime'];
    if (json['answers'] != null) {
      _answers = <Answers>[];
      json['answers'].forEach((v) {
        _answers!.add(Answers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['page'] = _page;
    data['guid'] = _guid;
    data['rivalguid'] = _rivalguid;
    data['remainingtime'] = _remainingtime;
    if (_answers != null) {
      data['answers'] = _answers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


