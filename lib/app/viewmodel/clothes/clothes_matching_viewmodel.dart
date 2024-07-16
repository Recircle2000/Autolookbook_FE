import 'dart:convert';
import 'package:autolookbook/app/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ClothesMatchingViewModel {
  Future<void> matchClothes(int temperature, {int? clothesId}) async {
  // 서버 url 구성
  String baseUrl = "http://" + dotenv.get("SERVER_IP") + "/api/Clothes/matching";
  String queryParams = "?temperature=$temperature";

  // Conditionally append the clothesId as a query parameter
  if (clothesId != null) {
    queryParams += "&Clothes_id=$clothesId";
  }

  // Complete URL with query parameters
  String url = baseUrl + queryParams;

  // Find the AuthViewModel to get the access token
  var authController = Get.find<AuthViewModel>();
  String? token = await authController.getAccessToken();

  // Headers, including the Authorization token
  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  // Sending a POST request without a body, as per the curl example
  var response = await http.post(Uri.parse(url), headers: headers);

  // Handling the response
  if (response.statusCode == 200) {
    print('Matching successful: ${response.body}');
  } else {
    Get.showSnackbar(GetSnackBar(
      title: "실패",
      message: "${response.statusCode} 에러가 발생했습니다.",
      icon: const Icon(Icons.error_outline,color: Colors.white),
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.redAccent,
    ),);
  }
}
}