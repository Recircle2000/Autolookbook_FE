import 'package:flutter/material.dart';
import 'package:autolookbook/utils/http_simple.dart';

import '../widget/login_snackbar.dart';
import 'package:autolookbook/model/user_join.dart';

class AddAccountPage extends StatefulWidget {
  AddAccountPage({Key? key}) : super(key: key);

  @override
  State<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final nickNameController = TextEditingController();
  final checkPWController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          TextFormField(
          controller: usernameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'id',
          ),
        ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'email',
              ),
            ),
            /*ElevatedButton(
                child: Text("이메일 가입 확인"),
                onPressed: () {
                  //isUniqe(emailController.text, context);
                  bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(emailController.text);
                  if (emailValid == false) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(emailErrorSnackBar());
                  }
                }),*/
            const SizedBox(height: 4.0),
            TextField(
              controller: nickNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'nickname',
              ),
            ),
            /*ElevatedButton(
              child: Text("닉네임 중복 확인"),
              onPressed: () {
                //isNickNameUniqe(nickNameController.text, context);
              },
            ),*/
            const SizedBox(height: 4.0),
            TextField(
              controller: pwController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'password',
              ),
            ),
            const SizedBox(height: 4.0),
            TextField(
              controller: checkPWController,
              obscureText: true, // 비밀번호 입력시 마지막 커서를 제외한 나머지를 검은 점으로
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'check password',
              ),
            ),
            ElevatedButton(
              child: Text("JOIN!"),
              onPressed: () {
                if (!(pwController.text == checkPWController.text)) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(passwordErrorSnackBar());
                } else {
                  debugPrint("모든 정보를 정상적으로 입력하였습니다");
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return addUser(usernameController.text, emailController.text,
                          nickNameController.text, pwController.text);
                    },
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}