import 'package:autolookbook/app/viewmodel/auth_viewmodel.dart';
import 'package:autolookbook/app/viewmodel/clothes/clothes_check_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart';
import 'package:get/get.dart';
import '../../models/uploadclothingitem.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:convert';

class ClothingViewModel extends GetxController {
  var isLoading = false.obs;
  var complete = 0.obs;
  var clothingItem = Rxn<UploadClothingItem>();
  var lastImagePath = ''.obs;
  var selectedClothesType = ''.obs;
  var selectedColorsType = ''.obs;
  String url = dotenv.get("SERVER_IP");
  ClothesCheckViewModel clothesCheckViewModel = Get.find<ClothesCheckViewModel>();
  File imageToUpload = File('');

  Future<void> uploadImage(File image) async {
    isLoading(true);
    lastImagePath("");
    clothingItem = Rxn<UploadClothingItem>();
    print(clothingItem.value);
    try {
      var imageWidth =
          (await decodeImageFromList(image.readAsBytesSync())).width;
      imageToUpload = image;

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
          'POST', Uri.parse('http://$url/api/Clothes/yolo'));
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        imageToUpload.path,
        filename: basename(imageToUpload.path),
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        selectedClothesType(responseData['category']);
        selectedColorsType(responseData['color']);
        clothingItem(UploadClothingItem(category: selectedClothesType.value, color: selectedColorsType.value));
        lastImagePath.value = imageToUpload.path;
        complete(0);
      } else {
        throw Exception('이미지 업로드 실패.');
      }
    } catch (e) {
      lastImagePath.value = imageToUpload.path;
      print(clothingItem.value);
      complete(1);
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
    clothingItem(UploadClothingItem(category: selectedClothesType.value, color: selectedColorsType.value));
    try {
      var authController = Get.find<AuthViewModel>();
      String? token = await authController.getAccessToken();

      var request = http.MultipartRequest('POST', Uri.parse('http://$url/api/Clothes/create'));

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
        clothesCheckViewModel.checkClothes();
        complete(0);
        lastImagePath = ''.obs;
        selectedClothesType = RxString('');
        selectedColorsType = RxString('');
        clothingItem = Rxn<UploadClothingItem>();
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
