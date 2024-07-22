import 'package:autolookbook/app/viewmodel/auth_viewmodel.dart';
import 'package:autolookbook/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:autolookbook/app/viewmodel/location_viewmodel.dart';
import 'package:autolookbook/app/viewmodel/weather_viewmodel.dart';


Future main() async {
  LocationViewModel locationViewModel = Get.put(LocationViewModel());
  WeatherViewModel weatherViewModel = Get.put(WeatherViewModel());
  await dotenv.load(fileName: ".env");	// 추가
  runApp(MyApp());
  await locationViewModel.getCurrentLocation();
  await weatherViewModel.fetchWeatherData(locationViewModel.currentLocation_xy.value.x,
      locationViewModel.currentLocation_xy.value.y);
  weatherViewModel.updateValue();

}

class MyApp extends StatelessWidget {
  final AuthViewModel authController = Get.put(AuthViewModel());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        popupMenuTheme: PopupMenuThemeData(
          color: Colors.white, // 팝업 메뉴의 배경 색상을 흰색으로 설정
        ),
        primarySwatch: Colors.blue,
        primaryColor: Colors.black, // 앱의 주요 색상을 검정색으로 설정
        scaffoldBackgroundColor: Colors.white, // 앱의 기본 배경 색상을 흰색으로 설정
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black), // 기본 텍스트 색상을 검정색으로 설정
          bodyMedium: TextStyle(color: Colors.black), // 기본 텍스트 색상을 검정색으로 설정
        ),
        appBarTheme: AppBarTheme(
          color: Colors.white,
        ),
        canvasColor: Colors.white, // 앱의 캔버스 색상을 흰색으로 설정
        dialogBackgroundColor: Colors.white, // 다이얼로그의 배경 색상을 흰색으로 설정
        elevatedButtonTheme:
        ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ).copyWith(
            minimumSize: WidgetStateProperty.all<Size>(Size(double.infinity, 40)),
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
