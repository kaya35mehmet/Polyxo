import 'dart:convert';
import 'package:flutter/foundation.dart';
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

Future<String> getuser() async {
 
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

    return data[0]["point"].toString();
  } else {
    throw Exception('Failed');
  }
}

deneme() async {
  var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  var request =
      http.Request('POST', Uri.parse('http://213.142.151.21:3000/api/message'));
  request.bodyFields = {'guid': '4dc9027b-bb71-4d72-800c-a8e83942303e'};
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    if (kDebugMode) {
      print(await response.stream.bytesToString());
    }
  } else {
    if (kDebugMode) {
      print(response.reasonPhrase);
    }
  }
}
