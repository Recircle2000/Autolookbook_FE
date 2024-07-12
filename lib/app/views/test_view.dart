import 'package:autolookbook/app/viewmodel/clothes/clothes_check_viewmodel.dart';
import 'package:autolookbook/app/viewmodel/location_viewmodel.dart';
import 'package:autolookbook/app/viewmodel/weather_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/weather_conditions.dart';
import '../viewmodel/gpt_viewmodel.dart';

class TestView extends StatelessWidget {
  final LocationController locationController = Get.put(LocationController());
  final WeatherService weatherService = Get.put(WeatherService());
  final ClothesCheckController clothesCheckController = Get.put(ClothesCheckController());
  final GeminiController geminiController = Get.put(GeminiController());

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
                  'gps 좌표: ${locationController.currentLocation.value.latitude}, ${locationController.currentLocation.value.longitude}')),
              Obx(() => Text(
                  'xy 좌표: ${locationController.currentLocation_xy.value.x}, ${locationController.currentLocation_xy.value.y}')),
              Obx(() =>
                  Text('변환 주소: ${locationController.currentAddress.value}')),
              Obx(() => Text('날씨: ${weatherService.T1H.value}°C')),
              Obx(() => Text(
                  '강수 형태: ${weatherService.PTY.value == 99 ? "정보 없음" : Rain_SnowConditions.rain_snowconditions[weatherService.PTY.value]}')),
              Obx(() => Text(
                  '하늘 상태: ${weatherService.SKY.value == 99 ? "정보 없음" : SkyConditions.skyConditions[weatherService.SKY.value]}')),
              Obx(() => Text('풍속: ${weatherService.WSD.value}m/s')),
              Obx(() => Text('강수량 : ${weatherService.RN1.value}mm')),
              Obx(() => Text('최저기온 : ${weatherService.TMN.value}°C')),
              Obx(() => Text('최고기온 : ${weatherService.TMX.value}°C')),
              Obx(() => Text('습도 : ${weatherService.REH.value}%')),
              Obx(() => Text('체감온도 : ${weatherService.WindChill.value}°C')),
              Obx(() => Text(geminiController.Text.value)),
              ElevatedButton(
                onPressed: () {
                  geminiController.getgemini(
                      weatherService.T1H.value.toString(),
                      weatherService.TMN.value.toString(),
                      weatherService.TMX.value.toString(),
                      weatherService.PTY.value,
                      weatherService.WSD.value.toString(),
                      weatherService.SKY.value,
                      weatherService.REH.value,
                      weatherService.WindChill.value.toString());
                },
                child: Text('Gemini 답변 재생성'),
              ),
              ElevatedButton(
                onPressed: () {
                  clothesCheckController.checkClothes();
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
