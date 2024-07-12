import 'package:autolookbook/app/viewmodel/clothes/clothes_add_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../utils/clothes_type.dart';
import '../utils/colors_type.dart';

class AddClothesView extends StatelessWidget {
  final ClothingViewModel clothingViewModel = Get.put(ClothingViewModel());

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
                onPressed: () async {
                  var image = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    clothingViewModel.uploadImage(io.File(image.path));
                  }
                },
                child: Text('옷 촬영'),
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
}
