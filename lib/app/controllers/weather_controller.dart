import 'dart:convert';
import 'dart:ffi';
import 'package:autolookbook/app/controllers/location_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/weather.dart'; // Import your WeatherData model
import 'package:intl/intl.dart';

class WeatherService extends GetxController {
  LocationController locationController = Get.put(LocationController());
  List<WeatherData> _weatherDataList = [];
  var T1H = 0.0.obs; // 기온
  var PTY = 99.obs; // 강수형태
  var WSD = 0.0.obs; // 풍속
  var RN1 = 0.0.obs; //시간별 강수량

  void onInit() async {
    super.onInit();
    await locationController.getCurrentLocation();
    await fetchWeatherData(locationController.currentLocation_xy.value.x,
        locationController.currentLocation_xy.value.y);
    updateValue();
    print("Location Controller Initialized");
  }

  Future<void> fetchWeatherData(int x, int y) async {
    try {
      DateTime now = DateTime.now();
      if (now.minute < 10) {
        now = now.subtract(Duration(hours: 1));
      }
      String baseDate = DateFormat('yyyyMMdd').format(now);
      String baseTime = DateFormat('HH00').format(now);

      if (baseTime == '0000') {
        baseDate =
            DateFormat('yyyyMMdd').format(now.subtract(Duration(days: 1)));
        baseTime = '2300';
      }

      final String serviceKey = dotenv.env['DATA_GO_KR_API_KEY'] ?? '';
      final String url =
          "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst"
          "?serviceKey=$serviceKey&pageNo=1&numOfRows=8&dataType=JSON"
          "&base_date=$baseDate&base_time=$baseTime&nx=$x&ny=$y";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = json.decode(response.body);
        final List<dynamic> items =
            decoded['response']['body']['items']['item'];
        _weatherDataList = items
            .map<WeatherData>((item) => WeatherData.fromJson(item))
            .toList();
        // Optionally, notify listeners or update the UI here
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      // Handle errors or notify listeners of the failure
    }
  }

  void updateValue() {
  final t1hData = _weatherDataList.firstWhereOrNull((data) => data.category == 'T1H');
  if (t1hData != null) {
    T1H.value = double.tryParse(t1hData.obsrValue) ?? 0.0;
  }

  final ptyData = _weatherDataList.firstWhereOrNull((data) => data.category == 'PTY');
  if (ptyData != null) {
    PTY.value = int.tryParse(ptyData.obsrValue) ?? 0;
  }

  final wsdData = _weatherDataList.firstWhereOrNull((data) => data.category == 'WSD');
  if (wsdData != null) {
    WSD.value = double.tryParse(wsdData.obsrValue) ?? 0.0;
  }

  final rn1Data = _weatherDataList.firstWhereOrNull((data) => data.category == 'RN1');
  if (rn1Data != null) {
    RN1.value = double.tryParse(rn1Data.obsrValue) ?? 0.0;
  }
}
}
