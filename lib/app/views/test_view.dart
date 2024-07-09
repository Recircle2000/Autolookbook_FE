import 'package:autolookbook/app/controllers/location_controller.dart';
import 'package:autolookbook/app/controllers/weather_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/weather_conditions.dart';

class TestView extends StatelessWidget {
  final LocationController locationController = Get.put(LocationController());
  final WeatherService weatherService = Get.put(WeatherService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('환영합니다!'),
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
                  '강수 형태: ${weatherService.PTY.value == 99 ? "정보 없음" : WeatherConditions.conditions[weatherService.PTY.value]}')),
              Obx(() => Text('풍속: ${weatherService.WSD.value}m/s')),
              Obx(() => Text('강수량 : ${weatherService.RN1.value}mm')),
              Obx(() => Text('최저기온 : ${weatherService.TMN.value}°C')),
              Obx(() => Text('최고기온 : ${weatherService.TMX.value}°C')),
            ],
          ),
        ),
      ),
    );
  }
}
