import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';

class RegisterController extends GetxController {
  var selectedImage = Rx<File?>(null);

  void register(
      String username,
      String password1,
      String password2,
      String nickname,
      String instagramId,
      int age) async {
    //에뮬레이터 == 10.0.2.2
    //내부 ip == 192.168.45.97
    var request = http.MultipartRequest('POST', Uri.parse('http://10.0.2.2:8000/api/user/create'));
    request.fields['username'] = username;
    request.fields['password1'] = password1;
    request.fields['password2'] = password2;
    request.fields['User_NickName'] = nickname;
    request.fields['User_Instagram_ID'] = instagramId;
    request.fields['User_Age'] = age.toString();

    if (selectedImage.value != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        selectedImage.value!.path,
        filename: basename(selectedImage.value!.path),
      ));
    }

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    if(password1 != password2){
      Get.showSnackbar(GetSnackBar(
        title: "에러",
        message: "비밀번호가 일치하지 않습니다.",
        icon: const Icon(Icons.error_outline,color: Colors.white),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.redAccent,
      ),);
    } else{
      if (response.statusCode == 204) {
        Get.showSnackbar(GetSnackBar(
          title: "성공",
          message: "회원가입 성공.",
          icon: const Icon(Icons.check_circle_outline,color: Colors.white),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.blueAccent,
        ),);
        Get.offAllNamed('/login');
      }
      else if(response.statusCode == 500){
        Get.showSnackbar(GetSnackBar(
          title: "에러",
          message: "알 수 없는 서버 에러",
          icon: const Icon(Icons.error_outline,color: Colors.white),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.redAccent,
        ),);
      } else if(response.statusCode == 409){
        Get.showSnackbar(GetSnackBar(
          title: "에러",
          message: "이미 존재하는 사용자 입니다.",
          icon: const Icon(Icons.error_outline,color: Colors.white),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.redAccent,
        ),);
      }
      else if (response.statusCode == 422) {
        var errorData = jsonDecode(responseData);
        var errorMsg = errorData['detail'][0]['msg'];
        Get.showSnackbar(GetSnackBar(
          title: "에러",
          message: errorMsg,
          icon: const Icon(Icons.error_outline,color: Colors.white),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.redAccent,
        ),);
      } else {
        Get.showSnackbar(GetSnackBar(
          title: "에러",
          message: "알 수 없는 에러",
          icon: const Icon(Icons.error_outline,color: Colors.white),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.redAccent,
        ),);
      }
    }
    }
}
