import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../controllers/register_controller.dart';

class RegisterView extends StatelessWidget {
  final RegisterController registerController = Get.put(RegisterController());
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController password1Controller = TextEditingController();
  final TextEditingController password2Controller = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController instagramIdController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원 가입'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: '이메일'),
            ),
            TextField(
              controller: password1Controller,
              decoration: InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            TextField(
              controller: password2Controller,
              decoration: InputDecoration(labelText: '비밀번호 확인'),
              obscureText: true,
            ),
            TextField(
              controller: nicknameController,
              decoration: InputDecoration(labelText: '닉네임(선택)'),
            ),
            TextField(
              controller: instagramIdController,
              decoration: InputDecoration(labelText: '인스타그램 아이디(선택)'),
            ),
            TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: '나이(선택)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  registerController.selectedImage.value = File(pickedFile.path);
                }
              },
              child: Text('프로필 사진(선택)'),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() {
                if (registerController.selectedImage.value != null) {
                  return Container(
                    width: 100.0, //  너비
                    height: 100.0, // 높이
                    child: Image.file(registerController.selectedImage.value!),
                  );
                } else {
                  return Text('이미지 업로드 안 함.');
                }
              }),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                registerController.register(
                  usernameController.text,
                  password1Controller.text,
                  password2Controller.text,
                  nicknameController.text,
                  instagramIdController.text,
                  int.tryParse(ageController.text) ?? 0,
                );
              },
              child: Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}
