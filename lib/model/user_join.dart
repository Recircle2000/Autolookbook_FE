import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // json.decode 함수를 사용하기 위함

addUser(String username, String email, String nickname, String password) {
  final response = http.post(
    Uri.parse('http://10.0.2.2:8000/api/user/create'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'nickname': nickname,
      'username' : username,
      'password1': password,
      'password2': password,
      'instagram': "fdd",
      'email': email,
    }),
  );

  return FutureBuilder(
    future: response,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      print(snapshot.hasData);
      if (snapshot.hasData) {
        return AlertDialog(
          title: Text("회원가입 성공"),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
                },
                child: Text("OK"))
          ],
        );
      } else if (snapshot.hasError) {
        return AlertDialog(
          title: Text("회원가입 실패"),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"))
          ],
        );
      }
      return AlertDialog(
        title: CircularProgressIndicator(),
      );
    },
  );
}