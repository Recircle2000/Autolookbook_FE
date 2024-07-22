import 'dart:convert';
import 'package:autolookbook/app/viewmodel/clothes/clothes_matching_viewmodel.dart';
import 'package:autolookbook/app/viewmodel/gemini_viewmodel.dart';
import 'package:autolookbook/app/viewmodel/location_viewmodel.dart';
import 'package:autolookbook/app/viewmodel/weather_viewmodel.dart';
import 'package:autolookbook/app/views/add_clothes/add_clothes_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../utils/weather_conditions.dart';
import 'package:intl/intl.dart';
import '../widgets/main_view/datedisplayWidget.dart';
import 'outing_view.dart';
import '../widgets/main_view/weathericonswidget.dart';
import 'package:autolookbook/app/viewmodel/openai_viewmodel.dart';


class MainView extends StatelessWidget {
  final LocationViewModel locationViewModel = Get.put(LocationViewModel());
  final WeatherViewModel weatherViewModel = Get.put(WeatherViewModel());
  final GeminiViewModel geminiViewModel = Get.put(GeminiViewModel());
  final ClothesMatchingViewModel clothesMatchingViewModel =
      Get.put(ClothesMatchingViewModel());
  final GptController openaiViewModel = Get.put(GptController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '메인',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Obx(() => locationViewModel.currentAddress.value.isEmpty
                          ? Icon(Icons.location_off)
                          : Icon(Icons.location_on)),
                      SizedBox(width: 8),
                      Obx(() => locationViewModel.currentAddress.value.isEmpty
                          ? LoadingAnimationWidget.prograssiveDots(
                              size: 20,
                              color: Colors.black,
                            )
                          : Text(locationViewModel.currentAddress.value)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 120,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DateDisplayWidget(),
                              Obx(() => Row(
                                    children: [
                                      Center(
                                        child: weatherViewModel.T1H.value
                                                    .toString() ==
                                                "99"
                                            ? LoadingAnimationWidget.waveDots(
                                                size: 50,
                                                color: Colors.black,
                                              )
                                            : Text(
                                                '${weatherViewModel.T1H.value}°C',
                                                style: TextStyle(
                                                    fontSize: 35,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        getWeatherIcon(
                                            weatherViewModel.COND.value),
                                        size: 24.0,
                                      ),
                                    ],
                                  )),
                              Obx(() => weatherViewModel.TMN.value == 99 &&
                                      weatherViewModel.TMX.value == 99
                                  ? Text('')
                                  : Text(
                                      '최저 ${weatherViewModel.TMN.value}° / 최고 ${weatherViewModel.TMX.value}°')),
                            ],
                          ),
                          Spacer(),
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(Icons.exit_to_app), // 밖으로 나가는 아이콘
                              iconSize: 48.0,
                              onPressed: () {
                                Get.to(() => OutingView());
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Obx(() => Center(
                        child: openaiViewModel.text.value.isEmpty
                            ? LoadingAnimationWidget.prograssiveDots(
                                size: 20,
                                color: Colors.black,
                              )
                            : Text(openaiViewModel.text.value,
                                textAlign: TextAlign.start),
                      )),
                  Divider(),
                  Obx(() => clothesMatchingViewModel.matchingClothesList.isEmpty
                      ? Center(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 165,
                                width: 165,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.add, size: 80),
                                      onPressed: () {
                                        Get.to(() => AddClothesView());
                                      },
                                    ),
                                    Text("옷 추가하기")
                                  ],
                                ),
                              ),
                              Text("옷을 더 추가하고, 온도별 옷차림을 확인하세요!"),
                            ],
                          ),
                        )
                      : Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '현재 기온에 맞는 맞춤 상의에요!',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                                Text(
                                  textAlign: TextAlign.left,
                                  '상의를 클릭하여 어울리는 하의를 확인하세요.',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: clothesMatchingViewModel
                                    .matchingClothesList
                                    .fold<List<Widget>>([],
                                        (previousValue, element) {
                                  var topsWidgets = element.tops.map((clothes) {
                                    return GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: SingleChildScrollView(
                                                child: Column(
                                                  children: element.bottoms
                                                      .map((bottomClothes) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(8.0),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey[100],
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  10),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                  8.0),
                                                          child: Image.memory(
                                                            base64Decode(
                                                                bottomClothes
                                                                    .clothesImage),
                                                            width: 165,
                                                            height: 165,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.memory(
                                              base64Decode(clothes.clothesImage),
                                              width: 165,
                                              height: 165,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList();
                                  return previousValue..addAll(topsWidgets);
                                }),
                              ),
                            ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ));
  }
}
