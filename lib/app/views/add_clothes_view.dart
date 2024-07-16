import 'package:autolookbook/app/viewmodel/clothes/clothes_add_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../utils/clothes_type.dart';
import '../utils/colors_type.dart';

class AddClothesView extends StatelessWidget {
  final ClothingViewModel clothingViewModel = Get.put(ClothingViewModel());
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('옷 추가')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: selectAndUploadImage,
                child: Text('갤러리에서 이미지 불러오기'),
              ),
              Obx(() {
                if (clothingViewModel.isLoading.isTrue) {
                  return LoadingAnimationWidget
                      .waveDots(
                    size: 50,
                    color: Colors.black,
                  );
                } else if (clothingViewModel.clothingItem.value != null) {
                  return Column(
                    children: [
                      Text('Category: ${ClothesType.clothesType[clothingViewModel.clothingItem.value!.category]}'),
                      Text('Color: ${ColorsType.colorsType[clothingViewModel.clothingItem.value!.color]}'),
                      if (clothingViewModel.lastImagePath.isNotEmpty)
                        Image.file(io.File(clothingViewModel.lastImagePath.value)),
                      ElevatedButton(
                        onPressed: () {
                          clothingViewModel.confirmAndUpload();
                        },
                        child: Text('이 옷 추가하기'),
                      ),
                    ],
                  );
                } else {
                  return SizedBox.shrink();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  void selectAndUploadImage() async {

    var image = await picker.pickImage(source: ImageSource.gallery);
    Fluttertoast.showToast(
        msg: "옷이 중앙으로 올 수 있도록 조정해 주세요.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);
    if (image != null) {
      ImageCropper imageCropper = ImageCropper();

      var croppedImage = await imageCropper.cropImage(
        sourcePath: image.path,

        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: '이미지 자르기',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            aspectRatioPresets:[
              CropAspectRatioPreset.square,
            ],
            initAspectRatio: CropAspectRatioPreset.square,


          ),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
            ],
          ),
        ],
      );
      if (croppedImage != null) {
        clothingViewModel.uploadImage(io.File(croppedImage.path));
      }
    }
  }
}
