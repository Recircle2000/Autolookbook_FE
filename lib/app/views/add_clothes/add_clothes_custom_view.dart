import 'package:autolookbook/app/utils/clothes_type.dart';
import 'package:autolookbook/app/utils/colors_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io' as io;
import '../../viewmodel/clothes/clothes_add_viewmodel.dart';

class AddClothesCustomView extends StatelessWidget {
  final ClothingViewModel clothingViewModel = Get.put(ClothingViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "옷을 수동으로 추가",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
              Text(
                "업로드할 옷의 카테고리와 색상을 직접 지정해 주세요.",
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 16.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child:
                    Image.file(io.File(clothingViewModel.lastImagePath.value)),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _showSelectionModalClothes(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Obx(() => Text(
                              clothingViewModel
                                      .selectedClothesType.value.isEmpty
                                  ? "옷의 종류"
                                  : ClothesType.clothesType[clothingViewModel
                                      .selectedClothesType.value]!,
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            )),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _showSelectionModalColors(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Obx(() => Text(
                              clothingViewModel.selectedColorsType.value.isEmpty
                                  ? "옷의 색상"
                                  : ColorsType.colorsType[clothingViewModel
                                      .selectedColorsType.value]!,
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: (!clothingViewModel
                            .selectedColorsType.value.isEmpty &&
                        !clothingViewModel.selectedClothesType.value.isEmpty)
                    ? () {
                        clothingViewModel.confirmAndUpload();
                        Get.back();
                      }
                    : null, // 조건에 따라 null을 할당하여 버튼 비활성화
                child: Text('추가하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSelectionModalClothes(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 300, // 적절한 높이로 조정
          child: ListView.separated(
            itemCount: ClothesType.clothesType.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: Colors.grey[300]), // 구분선
            itemBuilder: (context, index) {
              final key = ClothesType.clothesType.keys.toList()[index];
              final value = ClothesType.clothesType[key]!;

              // 선택된 항목 확인
              final isSelected =
                  key == clothingViewModel.selectedClothesType.value;

              return Container(
                child: ListTile(
                  title: Center(
                    child: Text(
                      value,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onTap: () {
                    clothingViewModel.selectedClothesType.value = key;
                    Navigator.pop(context);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showSelectionModalColors(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 300, // 적절한 높이로 조정
          child: ListView.separated(
            itemCount: ColorsType.colorsType.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: Colors.grey[300]), // 구분선
            itemBuilder: (context, index) {
              final key = ColorsType.colorsType.keys.toList()[index];
              final value = ColorsType.colorsType[key]!;

              // CSS3 컬러 코드를 hex 값으로 변환
              final hexColor = ColorsHEX.colorsHEX[key] ?? "000000";

              return ListTile(
                leading: Container(
                  width: 40.0,
                  height: 40.0,
                  color: Color(int.parse("0xff$hexColor")),
                ),
                title: Center(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () {
                  clothingViewModel.selectedColorsType.value = key;
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }
}
