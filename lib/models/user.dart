class User {
  int? _id;
  String? _guid;
  String? _email;
  String? _photopath;
  int? _point;
  String? _displayname;

  User({int? id, String? guid, String? email, String? photopath, int? point, String? displayname}) {
    if (id != null) {
      _id = id;
    }
    if (guid != null) {
      _guid = guid;
    }
    if (email != null) {
      _email = email;
    }
    if (photopath != null) {
      _photopath = photopath;
    }
    if (point != null) {
      _point = point;
    }
    if (displayname != null) {
      _displayname = displayname;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;

  String? get guid => _guid;
  set guid(String? guid) => _guid = guid;

  String? get email => _email;
  set email(String? email) => _email = email;
  String? get photopath => _photopath;
  set photopath(String? photopath) => _photopath = photopath;
  int? get point => _point;
  set point(int? point) => _point = point;
  String? get displayname => _displayname;
  set displayname(String? displayname) => _displayname = displayname;

  User.getLeaders(Map<String, dynamic> json) {
    _email = json['email'];
    _photopath = json['photopath'];
    _point = json['point'];
    _displayname = json['displayname'] ?? json['email'].toString().split("@").first;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['email'] = _email;
    data['photopath'] = _photopath;
    data['point'] = _point;
    data['displayname'] = _displayname;
    return data;
  }
}
