import 'package:autolookbook/app/viewmodel/auth_viewmodel.dart';
import 'package:autolookbook/app/viewmodel/clothes/clothes_check_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:autolookbook/app/models/clothes.dart';
import 'package:autolookbook/app/models/matchingclothes.dart';

class ClothesMatchingViewModel {
  var matchingClothesList = <MatchingClothesModel>[].obs;



  Future<void> matchClothes(int temperature, {int? clothesId}) async {
    // 서버 url 구성
    String baseUrl =
        "http://" + dotenv.get("SERVER_IP") + "/api/Clothes/matching";
    String queryParams = "?temperature=$temperature";

    if (clothesId != null) {
      queryParams += "&Clothes_id=$clothesId";
    }

    String url = baseUrl + queryParams;

    var authController = Get.find<AuthViewModel>();
    String? token = await authController.getAccessToken();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var response = await http.post(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      var firstKey = responseBody.keys.first;
      var isTemperatureBased = int.tryParse(firstKey) != null;

      if (isTemperatureBased) {
        // 온도별 데이터 처리
        matchingClothesList.clear();
        responseBody.forEach((temp, clothesData) async {
          MatchingClothesModel matchingClothes = MatchingClothesModel();
          await _processClothesData(clothesData, matchingClothes);
          matchingClothesList.add(matchingClothes);
          print("온도별 데이터 처리");

        });
      } else {
        matchingClothesList.clear();
        // 카테고리 정보 포함 데이터 처리
        MatchingClothesModel matchingClothes = MatchingClothesModel();
        await _processClothesData(responseBody, matchingClothes);
        matchingClothesList.add(matchingClothes);
      }
    } else {
      Get.showSnackbar(
        GetSnackBar(
          title: "실패",
          message: "${response.statusCode} 에러가 발생했습니다.",
          icon: const Icon(Icons.error_outline, color: Colors.white),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
  Future<void> _processClothesData(Map<String, dynamic> clothesData, MatchingClothesModel matchingClothes) async {
    for (var category in ['tops', 'bottoms', 'outerwear']) {
      var ids = clothesData[category];
      for (var id in ids) {
        Clothes? clothes = await findClothesById(id);
        if (clothes != null) {
          matchingClothes.add(clothes, category);
        }
      }
    }
  }
  Future<Clothes?> findClothesById(int clothesId) async {
    // ClothesCheckViewModel 인스턴스 찾기
    var clothesCheckViewModel = Get.find<ClothesCheckViewModel>();


    for (Clothes clothes in clothesCheckViewModel.clothesList) {
      if (clothes.clothesId == clothesId) {
        return clothes; // 일치하는 객체를 찾으면 반환
      }
    }

    return null; // 일치하는 객체가 없으면 null 반환
  }
}
