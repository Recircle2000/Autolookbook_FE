import 'dart:io';

import 'package:autolookbook/page/mainPage.dart';
import 'package:autolookbook/page/profile_page.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'package:autolookbook/model/user_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBodyWidget extends StatefulWidget {
  HomeBodyWidget(
      {Key? key,
        required this.bottomNavigationBarIndex,
        required this.setHomeIndex})
      : super(key: key);
  final int bottomNavigationBarIndex;
  Function setHomeIndex;
  @override
  State<HomeBodyWidget> createState() => _HomeBodyWidgetState();
}

class _HomeBodyWidgetState extends State<HomeBodyWidget> {
  final Future<ConnectivityResult> _initConnectivityResylt = Connectivity().checkConnectivity();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initConnectivityResylt,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // future 에서 받아오는 값이 에러가 있을 경우
          return Text("APP ERROR : ${snapshot.error}");
        } else if (snapshot.hasData) {
          // future에서 값을 잘 받아온 경우
          if (snapshot.data == ConnectivityResult.none) {
            return Center(
              child: TextButton(
                  child: Text("인터넷이 연결되어 있지 않음"),
                  onPressed: () {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('데이터 설정 오류'),
                            content: Text('인터넷 연결 설정이 안되어 있어 앱을 종료합니다'),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () {
                                    exit(0);
                                  },
                                  child: Text("OK"))
                            ],
                          );
                        });
                  }),
            );
          } else {
            switch (widget.bottomNavigationBarIndex) {
              case 0:

              case 1:

              case 2:
                return Center(
                  child: Column(
                    children: [
                      Text(
                          "${Provider.of<UserLoginProvider>(context).getUserLoginState}"),
                      ElevatedButton(
                        child: Text("계정 관리"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShowProfilePage(
                                setHomeIndex: widget.setHomeIndex,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              case 3:
                return Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                            "로그인 현황:${Provider.of<UserLoginProvider>(context).getUserLoginState}"),
                        Text("플러터 secure 저장소 확인"),
                        ElevatedButton(
                            onPressed: () async {
                              final secureStorage =
                              await SharedPreferences.getInstance();
                              Fluttertoast.showToast(
                                  msg: "secure storage : ${secureStorage.getString("access_token") ?? 0}",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                              );
                              debugPrint(
                                  "secure storage : ${secureStorage.getString("access_token") ?? 0}");
                            },
                            child: Text("토큰 출력(디버그용)"))
                      ],
                    ));
              default:

            }
          }
        }
        // future 값을 받아오는동안 보일 화면
        return CircularProgressIndicator();
      },
    );
  }
}