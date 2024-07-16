import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../viewmodel/clothes/clothes_check_viewmodel.dart';
import '../utils/clothes_type.dart';
import '../widgets/check_clothes_view/showclothesdetail.dart';

class CheckClothesView extends StatelessWidget {
  final ClothesCheckViewModel clothesCheckViewModel =
      Get.put(ClothesCheckViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('옷 확인'),
        scrolledUnderElevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) async {
              if (value == '전체') {
                await clothesCheckViewModel.checkClothes();
              } else {
                await clothesCheckViewModel.checkClothes(clotheCategory: value);
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
            child: Obx(() {
              if (clothesCheckViewModel.clothesList.isEmpty) {
                return Center(child: Text('옷 없음.'));
              } else {
                return RefreshIndicator(
                  onRefresh: () async {
                    await clothesCheckViewModel.checkClothes();
                  },
                  child: ListView.separated(
                    itemCount: clothesCheckViewModel.clothesList.length,
                    itemBuilder: (context, index) {
                      var clothes = clothesCheckViewModel.clothesList[index];
                      var clothesCategory = ClothesType.getClothesValue(clothes.clothesCategory ?? 'Unknown');
                      var formattedDate = DateFormat('yyyy-MM-dd').format(clothes.clothesCreateDate);
                      var lastFitFormattedDate = DateFormat('yyyy-MM-dd').format(clothes.clothesLastFitDate);

                      return ListTile(
                        title: Text(
                          clothesCategory ?? 'Unknown',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('추가: $formattedDate\n최근 입은 날짜: $lastFitFormattedDate'),
                        leading: FutureBuilder<Widget>(
                          future: _loadImage(clothes.clothesImage),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                              return SizedBox(
                                width: 50,
                                height: 50,
                                child: snapshot.data,
                              );
                            } else {
                              return SizedBox(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                        onTap: () => showClothesDetailPopup(context, clothes),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(),
                  ),
                );


              }
            }),
          ),
        ],
      ),
    );
  }
  Future<Widget> _loadImage(String base64Image) async {
    return Image.memory(
      base64Decode(base64Image),
      fit: BoxFit.cover,
    );
  }
}
