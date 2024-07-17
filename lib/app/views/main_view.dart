import 'package:autolookbook/app/viewmodel/gemini_viewmodel.dart';
import 'package:autolookbook/app/viewmodel/location_viewmodel.dart';
import 'package:autolookbook/app/viewmodel/weather_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../utils/weather_conditions.dart';
import 'package:intl/intl.dart';
import '../widgets/main_view/datedisplayWidget.dart';
import 'outing_view.dart';
import '../widgets/main_view/weathericonswidget.dart';

class MainView extends StatelessWidget {
  final LocationViewModel locationViewModel = Get.put(LocationViewModel());
  final WeatherViewModel weatherViewModel = Get.put(WeatherViewModel());
  final GeminiViewModel geminiViewModel = Get.put(GeminiViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('환영합니다!'),
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
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                    height: 115,
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
                                            ? LoadingAnimationWidget
                                                .waveDots(
                                                size: 50,
                                                color: Colors.black,
                                              )
                                            : Text(
                                                '${weatherViewModel.T1H.value}°C',
                                                style: TextStyle(
                                                    fontSize: 35,
                                                    fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                      ),
                                  SizedBox(width: 8),
                                  Icon(
                                    getWeatherIcon(weatherViewModel.COND.value),
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
                        child: geminiViewModel.Text.value.isEmpty
                            ? LoadingAnimationWidget.prograssiveDots(
                                size: 30,
                                color: Colors.black,
                              )
                            : Text(geminiViewModel.Text.value,
                                textAlign: TextAlign.center),
                      )),
                ],
              ),
            ),
          ),
        ));
  }
}
