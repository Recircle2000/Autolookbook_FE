import 'package:autolookbook/model/user_login.dart';
import 'package:autolookbook/page/login_page2.dart';
import 'package:autolookbook/widget/login_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginPage extends StatefulWidget{
  LoginPage({Key? key, required this.setHomeIndex}) : super(key: key);
  Function setHomeIndex;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  FocusNode _imailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  final imailController = TextEditingController();
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
        height: MediaQuery.of(context).size.width * 0.6,
        child: Column(
          children: [
            TextFormField(
              controller: imailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
              decoration: InputDecoration(labelText: '이메일'),
            ),
            TextFormField(
              focusNode: _passwordFocusNode,
              controller: pwController,
              obscureText: true,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) {
                goLogin();

                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage2(
                      username: imailController.text,
                      pw: pwController.text,
                      setHomeIndex: widget.setHomeIndex,
                    ),
                  ),
                );*/
              },
              decoration: InputDecoration(labelText: '비밀번호'),
            ),
            ElevatedButton(
              child: Text("LOGIN"),
              onPressed: () {
                goLogin();
                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage2(
                      username: imailController.text,
                      pw: pwController.text,
                      setHomeIndex: widget.setHomeIndex,
                    ),
                  ),
                );*/
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
  bool isEmail(String input) {
    final RegExp regex = RegExp(
        r'^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$'
    );
    return regex.hasMatch(input);
  }

  void goLogin(){
    if (isEmail(imailController.text)){
      if(pwController.text.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(passwordImptySnackBar());
      }
      else {
        httpUserLogin(context, imailController.text, pwController.text);
      }
    } else{
      ScaffoldMessenger.of(context).showSnackBar(emailErrorSnackBar());
    }
  }
}