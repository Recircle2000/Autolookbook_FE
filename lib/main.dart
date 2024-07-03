import 'package:autolookbook/app/controllers/auth_controller.dart';
import 'package:autolookbook/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
        primaryColor: Colors.black, // 앱의 주요 색상을 검정색으로 설정
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.black), // 기본 텍스트 색상을 검정색으로 설정
          bodyText2: TextStyle(color: Colors.black), // 기본 텍스트 색상을 검정색으로 설정
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.black, // ElevatedButton 내의 텍스트 색상을 흰색으로 설정
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black
          )
        ),

      ),
      initialRoute: '/login',  // 초기 라우트 설정
      getPages: AppRoutes.routes,
    );
  }
}
