

import 'package:autolookbook/app/controllers/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import '../models/clothingitem.dart';

class ClothingController extends GetxController {
  var isLoading = false.obs;
  var clothingItem = Rxn<ClothingItem>();
  var lastImagePath = ''.obs;
  String url = dotenv.get("SERVER_IP");

  Future<String> saveImageLocally(File image) async {
    final directory = await getApplicationDocumentsDirectory(); // 앱의 문서 디렉토리 경로를 얻습니다.
    final fileName = path.basename(image.path); // 이미지 파일의 이름을 얻습니다.
    final savedImage = await image.copy('${directory.path}/$fileName'); // 이미지를 로컬 디렉토리에 복사합니다.
    return savedImage.path; // 저장된 이미지의 경로를 반환합니다.
  }

  Future<void> uploadImage(File image) async {
    isLoading(true);
    try {
      var request = http.MultipartRequest('POST', Uri.parse('http://$url:8000/api/Clothes/yolo/'));
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        image.path,
        filename: basename(image.path),
      ));
      print(image.path);
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        String category = response.body;
        clothingItem(ClothingItem(category: category));
        lastImagePath.value = image.path;
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      print(e);
      Get.showSnackbar(const GetSnackBar(
        title: "에러",
        message: "옷 인식에 실패했습니다. 다시 시도해주세요.",
        icon: Icon(Icons.error_outline, color: Colors.white),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.redAccent,
      ));
    } finally {
      isLoading(false);
    }
  }

Future<void> confirmAndUpload() async {
  isLoading(true);
  try {
    //192.168.45.97
    //10.0.2.2
    var uri = Uri.parse('http://192.168.45.126:8000/api/Clothes/create');
    var request = http.MultipartRequest('POST', uri);

    var authController = Get.find<AuthController>();
    String? token = await authController.getAccessToken();

    if (token != null) {
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });
    }
    request.fields['user'] = 'someone';
    // 로컬에 저장된 이미지 파일을 사용하여 요청에 추가
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      lastImagePath.value,
      filename: path.basename(lastImagePath.value),
    ));

    var streamedResponse = await request.send();

    if (streamedResponse.statusCode == 204) {
      Get.snackbar('Success', 'Image uploaded successfully');
    } else {
      Get.snackbar('Error', 'Failed to upload image');
    }
  } catch (e) {
    print(e);
    Get.snackbar('Error', 'An error occurred while uploading');
  } finally {
    isLoading(false);
  }
}

}

