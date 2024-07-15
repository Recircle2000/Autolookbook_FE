import 'package:autolookbook/app/viewmodel/auth_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import '../../models/uploadclothingitem.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:convert';

class ClothingViewModel extends GetxController {
  var isLoading = false.obs;
  var clothingItem = Rxn<UploadClothingItem>();
  var lastImagePath = ''.obs;
  String url = dotenv.get("SERVER_IP");

  Future<String> saveImageLocally(File image) async {
    final directory =
        await getApplicationDocumentsDirectory(); // 앱의 문서 디렉토리 경로
    final fileName = path.basename(image.path); // 이미지 파일의 이름
    final savedImage =
        await image.copy('${directory.path}/$fileName'); // 이미지를 로컬 디렉토리에 복사
    return savedImage.path; // 저장된 이미지의 경로를 반환.
  }

  Future<void> uploadImage(File image) async {
    isLoading(true);
    try {
      var imageWidth =
          (await decodeImageFromList(image.readAsBytesSync())).width;
      File? imageToUpload = image;

      if (imageWidth > 1000) {
        var result = await FlutterImageCompress.compressAndGetFile(
          image.absolute.path,
          image.absolute.path
              .replaceFirst(RegExp(r'\.jpg$'), '_compressed.jpg'),
          minWidth: 640,
          quality: 88,
        );
        if (result != null) {
          imageToUpload = result;
        }
      }

      var request = http.MultipartRequest(
          'POST', Uri.parse('http://$url:8000/api/Clothes/yolo'));
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        imageToUpload.path,
        filename: basename(imageToUpload.path),
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {

        var responseData = jsonDecode(response.body);
        String category = responseData['category'];
        String color = responseData['color'];

        // 현재 인식된 옷의 카테고리와 색상을 저장.
        clothingItem(UploadClothingItem(category: category, color: color));
        lastImagePath.value = imageToUpload.path;
      } else {
        throw Exception('이미지 업로드 실패.');
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
      var authController = Get.find<AuthViewModel>();
      String? token = await authController.getAccessToken();

      var request = http.MultipartRequest('POST', Uri.parse('http://$url:8000/api/Clothes/create'));

      if (token != null) {
        request.headers.addAll({
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        });
      }

      request.fields['category'] = clothingItem.value!.category;
      request.fields['color'] = clothingItem.value!.color;

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        lastImagePath.value,
        filename: basename(lastImagePath.value),
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        Get.showSnackbar(const GetSnackBar(
          title: "성공",
          message: "이미지를 정상적으로 등록했어요.",
          icon: Icon(Icons.error_outline,color: Colors.white),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blueAccent,
        ),);
      } else if (response.statusCode == 400) {

        Get.showSnackbar(const GetSnackBar(
          title: "에러",
          message: "이미 존재하는 이미지 입니다.",
          icon: Icon(Icons.error_outline,color: Colors.white),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.redAccent,
        ),);
      }
      else {
        Get.showSnackbar(const GetSnackBar(
          title: "에러",
          message: "이미지 업로드에 실패 했어요.",
          icon: Icon(Icons.error_outline,color: Colors.white),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.redAccent,
        ),);
        //print('Response status: ${response.statusCode}');
        //print('Response body: ${response.body}');
      }
    } catch (e) {
      print(e);
      Get.snackbar('에러', '알 수 없는 에러 발생');
    } finally {
      isLoading(false);
    }
  }

}
