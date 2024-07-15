import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthViewModel extends GetxController {
  var isLoggedIn = false.obs;
  var isLoggingIn = false.obs;
  final storage = FlutterSecureStorage();
  String url = dotenv.get("SERVER_IP");

  void login(String username, String password) async {
    isLoggingIn.value = true;
    final response = await http.post(
      Uri.parse('http://$url/api/user/login'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'username': username,
        'password': password,
      },
    );

    isLoggingIn.value = false;

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'access_token', value: data['access_token']);
      await storage.write(key: 'username', value: data['username']);
      print("토큰값 : ${await storage.read(key: 'access_token')}");
      //print("토큰값 : ${getAccessToken()}");
      isLoggedIn.value = true;
      Get.offAllNamed('/home');
    } else if (response.statusCode == 401) {
      Get.showSnackbar(GetSnackBar(
        title: "에러",
        message: "이메일 또는 비밀번호를 확인하세요.",
        icon: const Icon(Icons.error_outline,color: Colors.white),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.redAccent,
      ),);
    } else if (response.statusCode == 422) {
      Get.showSnackbar(GetSnackBar(
        title: "에러",
        message: "이메일 또는 비밀번호를 모두 입력하세요.",
        icon: const Icon(Icons.error_outline,color: Colors.white),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.redAccent,
      ),);
    }
  }

  Future<void> logout() async {
    await storage.delete(key: 'access_token');
    await storage.delete(key: 'username');
    isLoggedIn.value = false;
    Get.showSnackbar(GetSnackBar(
      title: "로그아웃",
      message: "로그아웃 되었습니다.",
      icon: const Icon(Icons.error_outline,color: Colors.white),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.redAccent,
    ),);
    Get.offAllNamed('/login');
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: 'access_token');
  }

  Future<String?> getUsername() async {
    return await storage.read(key: 'username');
  }
}
