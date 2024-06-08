class User {
  int? id;
  String? guid;
  String? email;
  String? photopath;
  int? point;
  String? displayname;
  String? rivalisbot;
  DateTime? fortunewheel;
  DateTime? gift;

  User({
    this.id,
    this.guid,
    this.email,
    this.photopath,
    this.point,
    this.displayname,
    this.rivalisbot,
    this.fortunewheel,
    this.gift,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    guid = json['guid'];
    email = json['email'];
    photopath = json['photopath'];
    point = json['point'];
    displayname = json['displayname'] ?? json['email']?.split("@")?.first;
    rivalisbot = json['rivalisbot'];
    fortunewheel = DateTime.tryParse(json['fortunewheel'] ?? '');
    gift = DateTime.tryParse(json['gift'] ?? '');
  }

  User.fromLeadersJson(Map<String, dynamic> json) {
    email = json['email'];
    photopath = json['photopath'];
    point = json['point'];
    displayname = json['displayname'] ?? json['email']?.split("@")?.first;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['guid'] = guid;
    data['email'] = email;
    data['photopath'] = photopath;
    data['point'] = point;
    data['displayname'] = displayname;
    data['rivalisbot'] = rivalisbot;
    data['fortunewheel'] = fortunewheel?.toIso8601String();
    data['gift'] = gift?.toIso8601String();
    return data;
  }
}



// class User {
//   int? _id;
//   String? _guid;
//   String? _email;
//   String? _photopath;
//   int? _point;
//   String? _displayname;
//   String? _rivalisbot;
//   DateTime? _fortunewheel;
//   DateTime? _gift;

//   User({
//     int? id,
//     String? guid,
//     String? email,
//     String? photopath,
//     int? point,
//     String? displayname,
//     String? rivalisbot,
//     DateTime? fortunewheel,
//     DateTime? gift,
//   }) {
//     if (id != null) {
//       _id = id;
//     }
//     if (guid != null) {
//       _guid = guid;
//     }
//     if (email != null) {
//       _email = email;
//     }
//     if (photopath != null) {
//       _photopath = photopath;
//     }
//     if (point != null) {
//       _point = point;
//     }
//     if (displayname != null) {
//       _displayname = displayname;
//     }
//     if (rivalisbot != null) {
//       _rivalisbot = rivalisbot;
//     }
//     if (fortunewheel != null) {
//       _fortunewheel = fortunewheel;
//     }
//     if (gift != null) {
//       _gift = gift;
//     }
//   }

//   int? get id => _id;
//   set id(int? id) => _id = id;

//   String? get guid => _guid;
//   set guid(String? guid) => _guid = guid;

//   String? get email => _email;
//   set email(String? email) => _email = email;
//   String? get photopath => _photopath;
//   set photopath(String? photopath) => _photopath = photopath;
//   int? get point => _point;
//   set point(int? point) => _point = point;
//   String? get displayname => _displayname;
//   set displayname(String? displayname) => _displayname = displayname;
//   String? get rivalisbot => _rivalisbot;
//   set rivalisbot(String? rivalisbot) => _rivalisbot = rivalisbot;
//   DateTime? get fortunewheel => _fortunewheel;
//   set fortunewheel(DateTime? fortunewheel) => _fortunewheel = fortunewheel;
//   DateTime? get gift => _gift;
//   set gift(DateTime? gift) => _gift = gift;

//    User.getUser(Map<String, dynamic> json) {
//     _email = json['email'];
//     _photopath = json['photopath'];
//     _point = json['point'];
//     _gift = DateTime.tryParse(json['gift']);
//     _fortunewheel = DateTime.tryParse(json['fortunewheel']);
//     _displayname = json['displayname'] ?? json['email'].toString().split("@").first;
//   }

//   User.getLeaders(Map<String, dynamic> json) {
//     _email = json['email'];
//     _photopath = json['photopath'];
//     _point = json['point'];
//     _displayname =
//         json['displayname'] ?? json['email'].toString().split("@").first;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['email'] = _email;
//     data['photopath'] = _photopath;
//     data['point'] = _point;
//     data['displayname'] = _displayname;
//     return data;
//   }
// }
