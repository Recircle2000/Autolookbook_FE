import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> addUser(BuildContext context, String username, String password1, String password2, String nickname,String instagram_id, String age,String email, File file) async {
  final request = http.MultipartRequest('POST', Uri.parse('http://10.0.2.2:8000/api/user/create'));

  // 다른 필드 추가
  request.fields['username'] = username;
  request.fields['password1'] = password1;
  request.fields['password2'] = password2;
  request.fields['User_NickName'] = nickname;
  request.fields['User_Instagram_ID'] = instagram_id;
  request.fields['User_Age'] = age;
  request.fields['User_Imail'] = email;
// 파일 추가

  request.files.add(http.MultipartFile(
      'file',
      file.readAsBytes().asStream(),
      file.lengthSync(),
      filename: 'profile_imagew.jpg'
  ));
  final response = await request.send();

  // 응답 처리
  if (response.statusCode == 204) {
    // 성공적으로 생성된 경우
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("회원가입 성공"),
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
    );
  } else if (response.statusCode == 422) {
    // 422 에러 처리
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("422 에러"),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK")),
          ],
        );
      },
    );
  } else if (response.statusCode == 409) {
    // 409 에러 처리
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("409 에러"),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK")),
          ],
        );
      },
    );
  }
}
