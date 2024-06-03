import 'dart:convert';
import 'package:Buga/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String domain = 'http://213.142.151.21:3000/api';
Future<String> saveuser(
    String email, String photopath, String displayname) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String apiUrl = '$domain/saveuser';
  final response = await http.post(Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'photopath': photopath,
        'displayname': displayname,
      }));
  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    String guid = data[1];
    await prefs.setString('guid', guid);
    return guid;
  } else {
    throw Exception('Failed');
  }
}

Future<User> getuser() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? guid = prefs.getString('guid');
  String apiUrl = 'http://213.142.151.21:3000/api/getuser';

  final response = await http.post(Uri.parse(apiUrl),
      headers: {
        "Accept": "*/*",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: {
        'guid': guid,
      },
      encoding: Encoding.getByName("utf-8"));

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    return User.getUser(data[0]);
  } else {
    throw Exception('Failed');
  }
}
