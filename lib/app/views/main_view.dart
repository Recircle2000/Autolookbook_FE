import 'package:autolookbook/app/viewmodel/gpt_viewmodel.dart';
import 'package:autolookbook/app/viewmodel/location_viewmodel.dart';
import 'package:autolookbook/app/viewmodel/weather_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../utils/weather_conditions.dart';
import 'package:intl/intl.dart';
import '../widgets/datedisplayWidget.dart';

class MainView extends StatelessWidget {
  final LocationController locationController = Get.put(LocationController());
  final WeatherService weatherService = Get.put(WeatherService());
  final GeminiController geminiController = Get.put(GeminiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('환영합니다!'),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          // Add horizontal padding
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Obx(() => locationController.currentAddress.value.isEmpty
                          ? Icon(Icons.location_off)
                          : Icon(Icons.location_on)),
                      SizedBox(width: 8),
                      Obx(() => locationController.currentAddress.value.isEmpty
                          ? LoadingAnimationWidget.prograssiveDots(
                              size: 20,
                              color: Colors.black,
                            )
                          : Text(locationController.currentAddress.value)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300], // Slightly gray color
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                    ),
                    height: 111,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DateDisplayWidget(),
                              Obx(() => Center(
                                    child: weatherService.T1H.value
                                                .toString() ==
                                            "99"
                                        ? LoadingAnimationWidget
                                            .waveDots(
                                            size: 50,
                                            color: Colors.black,
                                          )
                                        : Text(
                                            '${weatherService.T1H.value}°C',
                                            style: TextStyle(
                                                fontSize: 35,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                  )),
                              Obx(() => weatherService.TMN.value == 99 &&
                                      weatherService.TMX.value == 99
                                  ? Text('')
                                  : Text(
                                      '최저 ${weatherService.TMN.value}° / 최고 ${weatherService.TMX.value}°')),
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
                                // 버튼이 눌렸을 때 실행할 코드 작성
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Obx(() => Center(
                        child: geminiController.Text.value.isEmpty
                            ? LoadingAnimationWidget.prograssiveDots(
                                size: 30,
                                color: Colors.black,
                              )
                            : Text(geminiController.Text.value,
                                textAlign: TextAlign.center),
                      )),
                ],
              ),
            ),
          ),
        ));
  }
}
