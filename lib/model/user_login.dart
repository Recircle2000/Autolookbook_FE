import 'dart:convert';

import 'package:http/http.dart' as http;

class UserLoginResponse {
  final String username;
  final String accessToken;
  final String token_type;

  UserLoginResponse(
      {required this.username,
        required this.accessToken,
        required this.token_type});

  factory UserLoginResponse.fromJson(Map<String, dynamic> json) {
    return UserLoginResponse(
        accessToken: json['access_token'],
        token_type: json['token_type'],
        username: json['username']
        );
  }
}

Future httpUserLogin(String username, String pw) async {
  var response = await http.post(
    Uri.parse('http://10.0.2.2:8000/api/user/login'),
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
    },
    body:{
      'username': username,
      'password': pw,
    },
  );
  /*if (response.statusCode == 422) {
   return UserLoginResponse.fromJson(jsonDecode(response.body));
  };*/
  return response;
}