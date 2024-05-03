import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ModifyInformationPage extends StatefulWidget {
  ModifyInformationPage({Key? key}) : super(key: key);

  @override
  State<ModifyInformationPage> createState() => _ModifyInformationPageState();
}

class _ModifyInformationPageState extends State<ModifyInformationPage> {
  final nicknameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: <Widget>[
                TextField(
                  controller: nicknameController,
                  decoration: const InputDecoration(labelText: 'nickname'),
                ),
                ElevatedButton(
                  child: const Text("CHANGE"),
                  onPressed: () async {
                    final secureStorage = await SharedPreferences.getInstance();
                    String accessToken =
                    secureStorage.getString('access_token').toString();
                    String refreshToken =
                    secureStorage.getString('refresh_token').toString();
                    var response = await http.patch(
                      Uri.parse("http://0.0.0.0:8000/user/nicknameChange"),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: jsonEncode(<String, String>{
                        "access_token": accessToken,
                        "refresh_token": refreshToken,
                        "nickname": nicknameController.text
                      }),
                    );
                    print("response body : " + response.body);
                  },
                )
              ],
            )),
      ),
    );
  }
}

class NicknameChangeRequest {}