import 'dart:convert';
import 'package:autolookbook/app/viewmodel/auth_viewmodel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ClothesMatchingController {
  Future<void> matchClothes(int temperature, {int? clothesId}) async {
    String url = dotenv.get("SERVER_IP");
    var authController = Get.find<AuthController>();
    String? token = await authController.getAccessToken();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var body = jsonEncode({
      'temperature': temperature,
      if (clothesId != null) 'Clothes_id': clothesId,
    });

    var response = await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      //성공
      print('Matching successful: ${response.body}');
    } else {
      //실패
      print('Failed to match clothes: ${response.statusCode}');
    }
  }
}