import 'package:autolookbook/app/viewmodel/clothes/clothes_check_viewmodel.dart';
import 'package:autolookbook/app/viewmodel/location_viewmodel.dart';
import 'package:autolookbook/app/viewmodel/weather_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/weather_conditions.dart';
import '../viewmodel/gpt_viewmodel.dart';

class TestView extends StatelessWidget {
  final LocationViewModel locationViewModel = Get.put(LocationViewModel());
  final WeatherViewModel weatherViewModel = Get.put(WeatherViewModel());
  final ClothesCheckViewModel clothesCheckViewModel = Get.put(ClothesCheckViewModel());
  final GeminiViewModel geminiViewModel = Get.put(GeminiViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('테스트 공간'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() => Text(
                  'gps 좌표: ${locationViewModel.currentLocation.value.latitude}, ${locationViewModel.currentLocation.value.longitude}')),
              Obx(() => Text(
                  'xy 좌표: ${locationViewModel.currentLocation_xy.value.x}, ${locationViewModel.currentLocation_xy.value.y}')),
              Obx(() =>
                  Text('변환 주소: ${locationViewModel.currentAddress.value}')),
              Obx(() => Text('날씨: ${weatherViewModel.T1H.value}°C')),
              Obx(() => Text(
                  '강수 형태: ${weatherViewModel.PTY.value == 99 ? "정보 없음" : Rain_SnowConditions.rain_snowconditions[weatherViewModel.PTY.value]}')),
              Obx(() => Text(
                  '하늘 상태: ${weatherViewModel.SKY.value == 99 ? "정보 없음" : SkyConditions.skyConditions[weatherViewModel.SKY.value]}')),
              Obx(() => Text('풍속: ${weatherViewModel.WSD.value}m/s')),
              Obx(() => Text('강수량 : ${weatherViewModel.RN1.value}mm')),
              Obx(() => Text('최저기온 : ${weatherViewModel.TMN.value}°C')),
              Obx(() => Text('최고기온 : ${weatherViewModel.TMX.value}°C')),
              Obx(() => Text('습도 : ${weatherViewModel.REH.value}%')),
              Obx(() => Text('체감온도 : ${weatherViewModel.WindChill.value}°C')),
              Obx(() => Text(geminiViewModel.Text.value)),
              ElevatedButton(
                onPressed: () {
                  geminiViewModel.getgemini(
                      weatherViewModel.T1H.value.toString(),
                      weatherViewModel.TMN.value.toString(),
                      weatherViewModel.TMX.value.toString(),
                      weatherViewModel.PTY.value,
                      weatherViewModel.WSD.value.toString(),
                      weatherViewModel.SKY.value,
                      weatherViewModel.REH.value,
                      weatherViewModel.WindChill.value.toString());
                },
                child: Text('Gemini 답변 재생성'),
              ),
              ElevatedButton(
                onPressed: () {
                  clothesCheckViewModel.checkClothes();
                },
                child: Text('Test Check Clothes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
