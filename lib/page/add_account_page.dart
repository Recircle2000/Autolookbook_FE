
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
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
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nicknameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _password2Controller = TextEditingController();
  TextEditingController _ageController = TextEditingController(text : '');
  TextEditingController _instagramIdController = TextEditingController(text : '');
  FocusNode _nicknameFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _password2FocusNode = FocusNode();
  FocusNode _ageFocusNode = FocusNode();
  FocusNode _instagramIdFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원 가입'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_nicknameFocusNode);
                },
                decoration: InputDecoration(labelText: '이메일 주소'),
              ),
              TextFormField(
                focusNode: _nicknameFocusNode,
                controller: _nicknameController,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
                decoration: InputDecoration(labelText: '닉네임'),
              ),
              TextFormField(
                focusNode: _passwordFocusNode,
                controller: _passwordController,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_password2FocusNode);
                },
                decoration: InputDecoration(labelText: '비밀번호'),
                obscureText: true,
              ),
              TextFormField(
                focusNode: _password2FocusNode,
                controller: _password2Controller,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_ageFocusNode);
                },
                decoration: InputDecoration(labelText: '비밀번호 확인'),
                obscureText: true,
              ),
              TextFormField(
                focusNode: _ageFocusNode,
                controller: _ageController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_instagramIdFocusNode);
                },
                decoration: InputDecoration(labelText: '나이(선택)'),
              ),
              TextFormField(
                focusNode: _instagramIdFocusNode,
                controller: _instagramIdController,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  addUser(
                    context,
                    _passwordController.text,
                    _password2Controller.text,
                    _nicknameController.text,
                    _instagramIdController.text,
                    _ageController.text,
                    _emailController.text,
                    /*_profileImage as File,*/
                  );
                },
                decoration: InputDecoration(labelText: '인스타그램 ID(선택)'),
              ),
              /*SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles();
                  if(result != null) {
                    setState(() {
                      _profileImage = File(result.files.single.path!);
                    });
                  }
                },

                child: Text('Pick Profile Image'),
              ),*/
              SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 50)),
                ),
                onPressed: () {
                  // Call the addUser function with the provided data
                  addUser(
                    context,
                    _passwordController.text,
                    _password2Controller.text,
                    _nicknameController.text,
                    _instagramIdController.text,
                    _ageController.text,
                    _emailController.text,
                    /*_profileImage as File,*/
                  );
                },
                child: Text('회원가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}