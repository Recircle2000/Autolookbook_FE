import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'package:autolookbook/app/viewmodel/location_viewmodel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/weather.dart'; // Import your WeatherData model
import 'package:intl/intl.dart';
import 'gpt_viewmodel.dart';

class WeatherService extends GetxController {
  LocationController locationController = Get.put(LocationController());
  List<WeatherData_Nest> _weatherDataList = [];
  List<WeatherData_Fest> _weatherDataList2 = [];

  var T1H = 99.obs; // 기온
  var PTY = 99.obs; // 강수형태
  var WSD = 0.0.obs; // 풍속
  var RN1 = 0.0.obs; //시간별 강수량
  var TMN = 99.obs; //최저기온
  var TMX = 99.obs; //최고기온
  var SKY = 99.obs; //하늘상태
  var REH = 110.obs; //습도
  //체감온도
  var WindChill = 100.0.obs;

  void onInit() async {
    super.onInit();
    await locationController.getCurrentLocation();
    await fetchWeatherData(locationController.currentLocation_xy.value.x,
        locationController.currentLocation_xy.value.y);
    updateValue();

    // GeminiController의 인스턴스를 찾아서 getgemini 메소드를 호출
    //final geminiController = Get.find<GeminiController>();
    //await geminiController.getgemini(T1H.value.toString(), TMN.value.toString(),
    //    TMX.value.toString(), PTY.value, WSD.value.toString(), SKY.value, REH.value);
    print("Controller Initialized");
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
      final String url_Ncst = // 초단기 실황
          "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst"
          "?serviceKey=$serviceKey&pageNo=1&numOfRows=8&dataType=JSON"
          "&base_date=$baseDate&base_time=$baseTime&nx=$x&ny=$y";

      String baseDate2;
      String baseTime2;

      List<String> baseTimes = [
        '0200',
        '0500',
        '0800',
        '1100',
        '1400',
        '1700',
        '2000',
        '2300'
      ];

// Convert current time to a format that matches the baseTimes format
      int currentTimeAsInt = int.parse(DateFormat('HHmm').format(now));

// Find the closest base time before the current time
      String closestBaseTime = baseTimes.reversed.firstWhere(
          (time) => int.parse(time) <= currentTimeAsInt,
          orElse: () => '2300');

      if (closestBaseTime == '2300' && currentTimeAsInt < 200) {
        // If current time is before 2 AM, use the previous day's date and 2300 as base time
        baseDate2 =
            DateFormat('yyyyMMdd').format(now.subtract(Duration(days: 1)));
        baseTime2 = '2300';
      } else {
        // Use the current date and the closest base time
        baseDate2 = DateFormat('yyyyMMdd').format(now);
        baseTime2 = closestBaseTime;
      }
      print('setting basetime : $baseDate2 , $baseTime2');
      final String url_Fcst = // 단기 예보
          "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"
          "?serviceKey=$serviceKey&pageNo=1&numOfRows=300&dataType=JSON"
          "&base_date=$baseDate2&base_time=$baseTime2&nx=$x&ny=$y";

      final response_Ncst = await http.get(Uri.parse(url_Ncst));
      final response_Fcst = await http.get(Uri.parse(url_Fcst));

      if (response_Ncst.statusCode == 200) {
        final Map<String, dynamic> decoded = json.decode(response_Ncst.body);
        final List<dynamic> items =
            decoded['response']['body']['items']['item'];
        _weatherDataList = items
            .map<WeatherData_Nest>((item) => WeatherData_Nest.fromJson(item))
            .toList();
        // Optionally, notify listeners or update the UI here
      } else {
        throw Exception('Failed to load weather data');
      }

      if (response_Fcst.statusCode == 200) {
        final Map<String, dynamic> decoded = json.decode(response_Fcst.body);
        final List<dynamic> items =
            decoded['response']['body']['items']['item'];
        _weatherDataList2 = items
            .map<WeatherData_Fest>((item) => WeatherData_Fest.fromJson(item))
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
    final t1hData =
    _weatherDataList.firstWhereOrNull((data) => data.category == 'T1H');
    if (t1hData != null) {
      T1H.value = double.tryParse(t1hData.obsrValue)?.round() ?? 0;
    }

    final ptyData =
    _weatherDataList.firstWhereOrNull((data) => data.category == 'PTY');
    if (ptyData != null) {
      PTY.value = int.tryParse(ptyData.obsrValue) ?? 0;
    }

    final wsdData =
    _weatherDataList.firstWhereOrNull((data) => data.category == 'WSD');
    if (wsdData != null) {
      WSD.value = double.tryParse(wsdData.obsrValue) ?? 0.0;
    }

    final rn1Data =
    _weatherDataList.firstWhereOrNull((data) => data.category == 'RN1');
    if (rn1Data != null) {
      RN1.value = double.tryParse(rn1Data.obsrValue) ?? 0.0;
    }

    final tmnData =
    _weatherDataList2.firstWhereOrNull((data) => data.category == 'TMN');
    if (tmnData != null) {
      TMN.value = double.tryParse(tmnData.fcstValue)?.round() ?? 0;
    }

    final tmxData =
    _weatherDataList2.firstWhereOrNull((data) => data.category == 'TMX');
    if (tmxData != null) {
      TMX.value = double.tryParse(tmxData.fcstValue)?.round() ?? 0;
    }

    final skyData =
    _weatherDataList2.firstWhereOrNull((data) => data.category == 'SKY');
    if (skyData != null) {
      SKY.value = int.tryParse(skyData.fcstValue) ?? 0;
    }

    final rehData =
    _weatherDataList.firstWhereOrNull((data) => data.category == 'REH');
    if (rehData != null) {
      REH.value = int.tryParse(rehData.obsrValue) ?? 0;
    }

    WindChill.value = double.parse((13.12 + 0.6215 * T1H.value - 11.37 * pow(WSD.value, 0.16) + 0.3965 * T1H.value * pow(WSD.value, 0.16)).toStringAsFixed(1));
    }

}
