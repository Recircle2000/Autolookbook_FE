import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodel/auth_viewmodel.dart';

class SettingsView extends StatelessWidget {
  final AuthViewModel authViewModel = Get.find<AuthViewModel>();

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
            Text('환경 설정 페이지'),
            SizedBox(height: 20),
            ElevatedButton(

              onPressed: () {
                authViewModel.logout();
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
