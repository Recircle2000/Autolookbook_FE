import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> addUser(BuildContext context, String password1, String password2, String nickname,String instagram_id, String age,String email,File file) async {

  //192.168.45.97 = 내 컴퓨터 공유기 로컬주소
  //localhost = 127.0.0.1
  var request = http.MultipartRequest('POST', Uri.parse('http://192.168.45.97:8000/api/user/create'));
  request.fields['username'] = email;
  request.fields['password1'] = password1;
  request.fields['password2'] = password2;
  request.fields['User_NickName'] = nickname;
  request.fields['User_Instagram_ID'] = instagram_id;
  request.fields['User_Age'] = age.toString();

  var pic = await http.MultipartFile.fromPath('file', file.path);
  request.files.add(pic);

  var response = await request.send();
  // final url = Uri.parse('http://192.168.45.97:8000/api/user/create')
  //     .replace(queryParameters: {
  //   'username': email,
  //   'password1': password1,
  //   'password2': password2,
  //   'User_NickName': nickname,
  //   'User_Instagram_ID': instagram_id,
  //   'User_Age': age.toString(),
  // });
  // final headers = {"accept": "*/*"};
  // final response = await http.post(url, headers: headers);

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
  else if (response.statusCode == 500) {
    // 409 에러 처리
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("서버 에러"),
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
