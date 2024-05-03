import 'package:flutter/material.dart';
import 'package:autolookbook/page/modify_information_page.dart';
import 'package:autolookbook/widget/login_join.dart';
import 'package:provider/provider.dart';

import '../model/user_state.dart';

class ShowProfilePage extends StatefulWidget {
  ShowProfilePage({Key? key, required this.setHomeIndex}) : super(key: key);
  Function setHomeIndex;

  @override
  State<ShowProfilePage> createState() => ShowProfilePageState();
}

class ShowProfilePageState extends State<ShowProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Provider.of<UserLoginProvider>(context).getUserLoginState
            ? Column(
          children: [
            const Text("secces Login"),
            ElevatedButton(
              child: const Text("계정 정보 변경"),
              onPressed: (() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ModifyInformationPage()),
                );
              }),
            ),
            ElevatedButton(
              child: const Text("로그아웃"),
              onPressed: () {
                Provider.of<UserLoginProvider>(context, listen: false)
                    .setUserLoginStateFalse();
              },
            ),
          ],
        )
            : Center(
          child: SizedBox(
            child: LoginJoinWidget(
              setHomeIndex: widget.setHomeIndex,
            ),
          ),
        ));
  }
}