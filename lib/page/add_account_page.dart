
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
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nicknameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _password2Controller = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _instagramIdController = TextEditingController();
  late File _profileImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Registration'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _nicknameController,
                decoration: InputDecoration(labelText: 'Nickname'),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              TextFormField(
                controller: _password2Controller,
                decoration: InputDecoration(labelText: 'Password2'),
                obscureText: true,
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
              ),
              TextFormField(
                controller: _instagramIdController,
                decoration: InputDecoration(labelText: 'Instagram ID'),
              ),
              SizedBox(height: 20),
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
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Call the addUser function with the provided data
                  addUser(
                    context,
                    _usernameController.text,
                    _passwordController.text,
                    _password2Controller.text,
                    _nicknameController.text,
                    _instagramIdController.text,
                    _ageController.text,
                    _emailController.text,
                    _profileImage as File,
                  );
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}