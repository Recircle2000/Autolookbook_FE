import 'package:autolookbook/app/controllers/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainView extends StatelessWidget {
  final LocationController locationController = Get.put(LocationController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => Center(
      child: Text(
          'Current Location: ${locationController.currentLocation.value.latitude}, ${locationController.currentLocation.value.longitude}'),
    ),
    );
  }
}
