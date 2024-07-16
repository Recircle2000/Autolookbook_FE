import 'package:autolookbook/app/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:autolookbook/app/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'clothes_check_viewmodel.dart';

class clothesDeleteViewModel {
  ClothesCheckViewModel checkViewModel = Get.find<ClothesCheckViewModel>();
  Future<void> deleteClothes(int clothesId) async {
    var authController = Get.find<AuthViewModel>();
    String? token = await authController.getAccessToken();
    String url = "http://" + dotenv.get("SERVER_IP") + "/api/Clothes/delete?Clothes_id=$clothesId";

    var response = await http.delete(Uri.parse(url), headers: {
      'Authorization': 'Bearer $token', // Assuming you need to send a token
    });

    if (response.statusCode == 200) {
      checkViewModel.checkClothes();
      Get.showSnackbar(GetSnackBar(
        title: "성공",
        message: "옷을 삭제 했어요.",
        icon: const Icon(Icons.delete, color: Colors.white),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.redAccent,
      ));
    } else {
      // Handle error
      print("Failed to delete clothes: ${response.body}");
    }
  }
}