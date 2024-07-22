import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../viewmodel/auth_viewmodel.dart';
import '../routes/app_routes.dart'; // 추가

class LoginView extends StatelessWidget {
  final AuthViewModel authViewModel = Get.find<AuthViewModel>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: usernameController,
                keyboardType: TextInputType.emailAddress, // 이메일 키보드
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@.]')),
                  // 영문자, 숫자, @ 입력 허용
                ],
                decoration: const InputDecoration(
                  labelText: '이메일',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (!authViewModel.isLoggingIn.value) {
                      authViewModel.login(
                        usernameController.text,
                        passwordController.text,
                      );
                    }
                  },
                  child: Obx(() => authViewModel.isLoggingIn.value
                      ? LoadingAnimationWidget.prograssiveDots(
                    size: 20,
                    color: Colors.white,
                  )
                      : Text('로그인')),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.REGISTER); // 회원가입 페이지로 이동
                },
                child: Text('회원 가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
