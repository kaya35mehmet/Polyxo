import 'dart:convert';
import 'package:Buga/models/user.dart';
import 'package:http/http.dart' as http;

String domain = 'http://213.142.151.21:3000/api';
Future<List<User>> getleaders() async {
  String apiUrl = '$domain/getleaders';
  final response = await http.get(Uri.parse(apiUrl), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });
  if (response.statusCode == 200) {
    Iterable res = json.decode(response.body);
    return res.map((e) => User.getLeaders(e)).toList();
  } else {
    throw Exception('Failed');
  }
}
