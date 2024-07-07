import 'package:autolookbook/app/controllers/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainView extends StatelessWidget {
  final LocationController locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메인'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                'Current Location: ${locationController.currentLocation.value.latitude}, ${locationController.currentLocation.value.longitude}'),
            // 여기에 다른 자식 위젯들 추가
          ],
        ),
      ),
    );
  }
}
