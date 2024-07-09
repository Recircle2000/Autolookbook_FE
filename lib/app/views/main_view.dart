import 'package:autolookbook/app/controllers/location_controller.dart';
import 'package:autolookbook/app/controllers/weather_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/weather_conditions.dart';
import 'package:intl/intl.dart';
import '../widgets/datedisplayWidget.dart';

class MainView extends StatelessWidget {
  final LocationController locationController = Get.put(LocationController());
  final WeatherService weatherService = Get.put(WeatherService());

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
                      Icon(Icons.location_on),
                      SizedBox(width: 8),
                      Obx(() => Text(locationController.currentAddress.value)),
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
                              Obx(() => Text(
                                    '${weatherService.T1H.value}°C',
                                    style: TextStyle(
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold),
                                  )),
                              Obx(() => Text('최저 ${weatherService.TMN.value}° / 최고 ${weatherService.TMX.value}°')),
                            ],
                          ),
                          Spacer(),
                          Container(
                            height: 100, // Specify the height
                            width: 100, // Specify the width to make it a square
                            decoration: BoxDecoration(
                              color: Colors.white, // Set the color to white
                              borderRadius: BorderRadius.circular(10), // Rounded corners
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5), // Shadow color with some transparency
                                  spreadRadius: 2, // Spread radius
                                  blurRadius: 7, // Blur radius
                                  offset: Offset(0, 3), // Changes position of shadow
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(Icons.exit_to_app), // 밖으로 나가는 아이콘
                              iconSize: 48.0,
                              onPressed: () {
                                // 버튼이 눌렸을 때 실행할 코드를 여기에 작성하세요.
                                // 예: Navigator.pop(context); // 현재 화면을 닫고 이전 화면으로 돌아갑니다.
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
