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

Future<void> updatefortunewheel(guid, point) async {
  String apiUrl = '$domain/updatefortunewheel';

  var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  var request = http.Request('POST', Uri.parse(apiUrl));
  request.bodyFields = {'guid': guid, 'point': point};
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  } else {
    print(response.reasonPhrase);
  }
}

Future<void> updategift(guid, point) async {
  String apiUrl = '$domain/updategift';
  
  var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  var request = http.Request('POST', Uri.parse(apiUrl));
  request.bodyFields = {'guid': guid, 'point': point};
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  
  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  } else {
    print(response.reasonPhrase);
  }
}
