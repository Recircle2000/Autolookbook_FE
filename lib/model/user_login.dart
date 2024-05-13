import 'dart:convert';
import 'package:autolookbook/model/user_state.dart';
import 'package:autolookbook/widget/login_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

Future httpUserLogin(BuildContext context, String username, String pw) async {
  var response = await http.post(
    Uri.parse('http://192.168.45.97:8000/api/user/login'),
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
  if (response.statusCode == 200) {
    var loginResponse = UserLoginResponse.fromJson(
        jsonDecode(response.body));
    final secureStorage =
    await SharedPreferences.getInstance();
    Provider.of<UserLoginProvider>(context,
        listen: false)
        .setUserLoginStateTrue();
    secureStorage.setString(
        'access_token', loginResponse.accessToken);
    ScaffoldMessenger.of(context).showSnackBar(loginCompleteSnackBar());
    Navigator.pushNamedAndRemoveUntil(
        context, '/', (route) => false);
    /*showDialog(
        context: context,
        builder: (BuildContext context) {
      return AlertDialog(
        title: Text("로그인 성공"),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false);
              },
              child: Text("OK")),
        ],
      );
    },
    );*/
  }
  if (response.statusCode == 401) {
    final responseBody = jsonDecode(response.body);
    final errorMessage = responseBody['detail'];
    ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(errorMessage));
  }
}