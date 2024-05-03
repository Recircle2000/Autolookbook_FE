import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:autolookbook/widget/login_snackbar.dart';
import 'package:http/http.dart' as http;

isUniqe(String inputString, BuildContext context) async {
  String url = "http://0.0.0.0:8000/user/checkEmail/" + inputString + "/";
  var response = await http.get(Uri.parse(url));
  var responseBody = response.body;
  Map<String, dynamic> checkResponse = jsonDecode(responseBody);
  bool localstate = false;
  if (checkResponse['result'] == 'use') {
    localstate = true;
  } else if (checkResponse['result'] == 'not use') {
    localstate = false;
  }
  return ScaffoldMessenger.of(context)
      .showSnackBar(inputCheckSnackBar(localstate));
}

isNickNameUniqe(String inputString, BuildContext context) async {
  String url = "http://0.0.0.0:8000/user/checkNickName/" + inputString + "/";
  var response = await http.get(Uri.parse(url));
  var responseBody = response.body;
  Map<String, dynamic> checkResponse = jsonDecode(responseBody);
  bool localstate = false;
  if (checkResponse['result'] == 'use') {
    localstate = true;
  } else if (checkResponse['result'] == 'not use') {
    localstate = false;
  }
  return ScaffoldMessenger.of(context)
      .showSnackBar(inputCheckSnackBar(localstate));
}