import 'package:autolookbook/page/login_page2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget{
  LoginPage({Key? key, required this.setHomeIndex}) : super(key: key);
  Function setHomeIndex;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  final usernameController = TextEditingController();
  final pwController = TextEditingController();

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      leading: Container(),
    ),
    body: Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.width * 0.5,
        child: Column(
          children: [
            TextFormField(
              controller: usernameController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'ID'),
            ),
            TextFormField(
              controller: pwController,
              obscureText: true,
              decoration: InputDecoration(labelText: '비밀번호'),
            ),
            ElevatedButton(
              child: Text("LOGIN"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage2(
                      username: usernameController.text,
                      pw: pwController.text,
                      setHomeIndex: widget.setHomeIndex,
                    ),
                  ),
                );
              },
            ),
            ElevatedButton(
                child: Text("return to home"),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    ),
  );
}
}