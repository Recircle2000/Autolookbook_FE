import 'package:autolookbook/app/controllers/clothing_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';

class AddClothesView extends StatelessWidget {
  final ClothingController viewModel = Get.put(ClothingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('옷 추가')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                var image = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (image != null) {
                  viewModel.uploadImage(io.File(image.path));
                }
              },
              child: Text('옷 촬영'),
            ),
            Obx(() {
              if (viewModel.isLoading.isTrue) {
                return CircularProgressIndicator();
              } else if (viewModel.clothingItem.value != null) {
                return Column(
                  children: [
                    Text('Category: ${viewModel.clothingItem.value!.category}'),
                    if (viewModel.lastImagePath.isNotEmpty) // Step 3: Check if the image path is not null
                      Image.file(io.File(viewModel.lastImagePath.value)), // Display the image
                    ElevatedButton(
                      onPressed: () {
                        viewModel.confirmAndUpload();
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
    );
  }
}
