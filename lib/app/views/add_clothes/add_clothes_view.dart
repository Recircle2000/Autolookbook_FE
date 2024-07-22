import 'package:autolookbook/app/viewmodel/clothes/clothes_add_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../utils/clothes_type.dart';
import '../../utils/colors_type.dart';
import 'add_clothes_custom_view.dart';

class AddClothesView extends StatelessWidget {
  final ClothingViewModel clothingViewModel = Get.put(ClothingViewModel());
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "옷을 추가해보세요.",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
              Text(
                "이미지를 추가하면 자동으로 카테고리와 색상을 분석합니다.",
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.start,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () => selectAndUploadImage(true),
                    child: Row(
                      children: [
                        Icon(Icons.camera_alt_outlined),
                        SizedBox(width: 8.0),
                        Text('사진 촬영하기'),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                  )),
                  SizedBox(width: 16.0),
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () => selectAndUploadImage(false),
                    child: Row(
                      children: [
                        Icon(Icons.browse_gallery),
                        SizedBox(width: 8.0),
                        Text('사진 불러오기'),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          clothingViewModel.clothingItem.value?.category == 0
                              ? Colors.black
                              : Colors.grey,
                    ),
                  )),
                ],
              ),
              SizedBox(height: 10),
              Obx(() {
                if (clothingViewModel.isLoading.isTrue) {
                  return LoadingAnimationWidget.waveDots(
                    size: 50,
                    color: Colors.black,
                  );
                } else if (clothingViewModel.clothingItem.value != null) {
                  return Column(
                    children: [
                      if (clothingViewModel.lastImagePath.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                              io.File(clothingViewModel.lastImagePath.value)),),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                '${ClothesType.clothesType[clothingViewModel.clothingItem.value!.category]}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: hexToColor(ColorsHEX.colorsHEX[clothingViewModel.clothingItem.value!.color] ?? "ffffff"),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                '${ColorsType.colorsType[clothingViewModel.clothingItem.value!.color]}',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: getTextColorBasedOnBackground(hexToColor(ColorsHEX.colorsHEX[clothingViewModel.clothingItem.value!.color] ?? "ffffff")),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      ElevatedButton(
                        onPressed: () {
                          clothingViewModel.confirmAndUpload();
                        },
                        child: Text('이 옷 추가하기'),
                      ),
                      TextButton(
                          onPressed: () {
                            Get.to(() => AddClothesCustomView());
                            },
                          child: Text('카테고리/색상이 일치하지 않나요?')),
                    ],
                  );
                } else if(clothingViewModel.complete.value == 1){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                            io.File(clothingViewModel.lastImagePath.value)),),
                      Text("카테고리 / 색상 인식에 실패. \n다음 버튼을 눌러 직접 입력해주세요.",
                        textAlign: TextAlign.start,),
                      ElevatedButton(
                          onPressed: () {
                            Get.to(() => AddClothesCustomView());
                          },
                          child: Text('다음')),
                    ],
                  );
                } else {return Container();}
                }
              ),
            ],
          ),
        ),
      ),
    );
  }

  void selectAndUploadImage(bool istake) async {
    XFile? image;
    if (!istake) {
      image = await picker.pickImage(source: ImageSource.gallery);
    } else {
      image = await picker.pickImage(source: ImageSource.camera);
    }

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
            aspectRatioPresets: [
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

  Color hexToColor(String hexCode) {
    final buffer = StringBuffer();
    if (hexCode.length == 6 || hexCode.length == 7) buffer.write('ff'); // ARGB: fully opaque
    buffer.write(hexCode.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  Color getTextColorBasedOnBackground(Color backgroundColor) {
    // 색상의 밝기 계산
    double brightness = (backgroundColor.red * 299 +
        backgroundColor.green * 587 +
        backgroundColor.blue * 114) / 1000;
    return brightness > 128 ? Colors.black : Colors.white; // 밝으면 검정색, 어두우면 흰색
  }
}
