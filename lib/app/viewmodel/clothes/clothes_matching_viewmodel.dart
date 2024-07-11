import 'dart:convert';
import 'package:autolookbook/app/viewmodel/auth_viewmodel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ClothesMatchingController {
  Future<void> matchClothes(int temperature, {int? clothesId}) async {
    String url = dotenv.get("SERVER_IP"); // Replace with your actual server URL
    var authController = Get.find<AuthController>();
    String? token = await authController.getAccessToken(); // Implement this method to retrieve the user's token

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
      // Handle successful response
      print('Matching successful: ${response.body}');
    } else {
      // Handle error
      print('Failed to match clothes: ${response.statusCode}');
    }
  }

  // Placeholder for getAccessToken method
  Future<String> getAccessToken() async {
    // Implement token retrieval logic
    return 'your_access_token';
  }
}