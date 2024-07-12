import 'dart:convert';

import 'package:autolookbook/app/viewmodel/auth_viewmodel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import '../../models/clothes.dart';

class ClothesCheckController extends GetxController {
  var clothesList = <Clothes>[].obs;

  Future<void> checkClothes({String? clotheCategory, int? clotheId}) async {
    var authController = Get.find<AuthController>();
    String? token = await authController.getAccessToken();
    String url = "http://" + dotenv.get("SERVER_IP") + ":8000/api/Clothes/check";

    Map<String, dynamic> queryParams = {};
    if (clotheCategory != null) queryParams['Clothe_category'] = clotheCategory;
    if (clotheId != null) queryParams['Clothe_id'] = clotheId.toString();
    var uri = Uri.parse(url).replace(queryParameters: queryParams);

    var headers = {
      'Authorization': 'Bearer $token',
    };

    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      printFormattedJson(response.body);
      var jsonData = json.decode(response.body);
      clothesList.value = jsonData.map<Clothes>((json) => Clothes.fromJson(json)).toList();
      print("debug");
    } else {
      // Handle error
      print('Failed to check clothes: ${response.statusCode}');
    }
  }
  void printFormattedJson(String responseBody) {
    var decodedJson = jsonDecode(responseBody);
    var prettyString = JsonEncoder.withIndent('').convert(decodedJson);
    print(prettyString);
  }

}
