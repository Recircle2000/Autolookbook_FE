import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:autolookbook/page/navBarPage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:autolookbook/model/user_login.dart';
import 'package:autolookbook/model/user_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage2 extends StatefulWidget {
  LoginPage2(
      {Key? key,
        required this.username,
        required this.pw,
        required this.setHomeIndex})
      : super(key: key);
  final String username;
  final String pw;
  Function setHomeIndex;
  @override
  State<LoginPage2> createState() => _LoginPage2State();
}

class _LoginPage2State extends State<LoginPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.4,
          child: FutureBuilder(
              future: httpUserLogin(context, widget.username, widget.pw),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.statusCode == 200) {
                    var loginResponse = UserLoginResponse.fromJson(
                        jsonDecode(snapshot.data.body));

                    return Column(
                      children: [
                        Text("로그인 성공"),
                        TextButton(
                          child: Text("return to home"),
                          onPressed: () async {
                            widget.setHomeIndex(0);
                            final secureStorage =
                            await SharedPreferences.getInstance();
                            secureStorage.setString(
                                'access_token', loginResponse.accessToken);
                            /*await secureStorage.setString(
                                'refresh_token', loginResponse.refreshToken);*/
                            Provider.of<UserLoginProvider>(context,
                                listen: false)
                                .setUserLoginStateTrue();
                            Navigator.popUntil(
                                context, ModalRoute.withName('/'));
                          },
                        )
                      ],
                    );
                  } else if (snapshot.data.statusCode == 422) {
                    return Column(
                      children: [
                        Text("로그인 실패"),
                        TextButton(
                          child: Text("return"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  } else if (snapshot.data.statusCode == 202) {
                    return Column(
                      children: [
                        Text("비밀번호 에러"),
                        TextButton(
                          child: Text("return"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  }
                  else if (snapshot.data.statusCode == 401) {
                    final responseBody = jsonDecode(snapshot.data.body);
                    final errorMessage = responseBody['detail'];
                    return Column(
                      children: [
                        Text(errorMessage),
                        TextButton(
                          child: Text("return"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  }
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return const SizedBox(
                  height: 4,
                  width: 4,
                  child: CircularProgressIndicator.adaptive(),
                );
              }),
        ),
      ),
    );
  }
}