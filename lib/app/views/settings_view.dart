import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class SettingsView extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('환경 설정'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              authController.getAccessToken() == null
                  ? 'Access Token이 없습니다.'
                  : 'Access Token: ${authController.getAccessToken()}',
              style: TextStyle(fontSize: 2),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                authController.logout();
                Get.offAllNamed('/login');
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}