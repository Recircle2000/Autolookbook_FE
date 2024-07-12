import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodel/clothes/clothes_check_viewmodel.dart';
import '../models/clothes.dart';
import '../utils/clothes_type.dart';

class CheckClothesView extends StatelessWidget {
  final ClothesCheckController clothesCheckController = Get.put(ClothesCheckController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('옷 확인'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) async {
              if (value == '전체') {
                await clothesCheckController.checkClothes();
              } else {
                await clothesCheckController.checkClothes(clotheCategory: value);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: '전체',
                  child: Text('전체'),
                ),
                ...ClothesType.clothesType.entries.map((entry) {
                  return PopupMenuItem<String>(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
              ];
            },
            icon: Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
                  () {
                if (clothesCheckController.clothesList.isEmpty) {
                  return Center(child: Text('옷 없음.'));
                } else {
                  return ListView.builder(
                    itemCount: clothesCheckController.clothesList.length,
                    itemBuilder: (context, index) {
                      var clothes = clothesCheckController.clothesList[index];
                      var clothesCategory = ClothesType.getClothesValue(clothes.clothesCategory ?? 'Unknown');
                      return ListTile(
                        title: Text(clothesCategory ?? 'Unknown'),
                        subtitle: Text('생성: ${clothes.clothesCreateDate}, 최근 입은 날짜: ${clothes.clothesLastFitDate}'),
                        leading: Image.memory(base64Decode(clothes.clothesImage)),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}