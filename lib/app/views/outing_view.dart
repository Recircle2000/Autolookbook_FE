import 'package:autolookbook/app/viewmodel/clothes/clothes_check_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class OutingView extends StatelessWidget {
  final ClothesCheckViewModel clothesCheckViewModel = Get.put(ClothesCheckViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('외출하기',
          style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('외출하기 페이지입니다.'),
          ],
        ),
      ),
    );
  }
}
