import 'dart:convert';
import 'dart:math';
import 'package:autolookbook/app/models/matchingclothes.dart';
import 'package:autolookbook/app/viewmodel/location_viewmodel.dart';
import '../viewmodel/clothes/clothes_matching_viewmodel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/weather.dart';
import 'package:intl/intl.dart';
import 'gemini_viewmodel.dart';

class WeatherViewModel extends GetxController {
  LocationViewModel locationViewModel = Get.put(LocationViewModel());

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
  var COND = "".obs; //하늘+강수형태 = 날씨상태
  //체감온도
  var WindChill = 100.0.obs;

  void onInit() async {
    super.onInit();
    // GeminiController의 인스턴스를 찾아서 getgemini 메소드를 호출
    //final geminiController = Get.find<GeminiController>();
    //await geminiController.getgemini(T1H.value.toString(), TMN.value.toString(),
    //    TMX.value.toString(), PTY.value, WSD.value.toString(), SKY.value, REH.value);
    //print("Controller Initialized");
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

// int 타입으로 시간 변환
      int currentTimeAsInt = int.parse(DateFormat('HHmm').format(now));

// api가 원하는 basetime 시간대로 변환
      String closestBaseTime = baseTimes.reversed.firstWhere(
          (time) => int.parse(time) <= currentTimeAsInt,
          orElse: () => '2300');

      if (closestBaseTime == '2300' && currentTimeAsInt < 200) {
        // 오전 2시 이전의 경우, 전 날의 23시 데이터 요청
        baseDate2 =
            DateFormat('yyyyMMdd').format(now.subtract(Duration(days: 1)));
        baseTime2 = '2300';
      } else {
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
        _weatherDataList = await items
            .map<WeatherData_Nest>((item) => WeatherData_Nest.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to load weather data');
      }

      if (response_Fcst.statusCode == 200) {
        final Map<String, dynamic> decoded = json.decode(response_Fcst.body);
        final List<dynamic> items =
            decoded['response']['body']['items']['item'];
        _weatherDataList2 = await items
            .map<WeatherData_Fest>((item) => WeatherData_Fest.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
    }
  }

  Future<void> updateValue() async {
    final t1hData = await
    _weatherDataList.firstWhereOrNull((data) => data.category == 'T1H');
    if (t1hData != null) {
      T1H.value = await double.tryParse(t1hData.obsrValue)?.round() ?? 0;
    }

    final ptyData = await
    _weatherDataList.firstWhereOrNull((data) => data.category == 'PTY');
    if (ptyData != null) {
      PTY.value = await int.tryParse(ptyData.obsrValue) ?? 0;
    }

    final wsdData = await
    _weatherDataList.firstWhereOrNull((data) => data.category == 'WSD');
    if (wsdData != null) {
      WSD.value = await double.tryParse(wsdData.obsrValue) ?? 0.0;
    }

    final rn1Data = await
    _weatherDataList.firstWhereOrNull((data) => data.category == 'RN1');
    if (rn1Data != null) {
      RN1.value = await double.tryParse(rn1Data.obsrValue) ?? 0.0;
    }

    final tmnData = await
    _weatherDataList2.firstWhereOrNull((data) => data.category == 'TMN');
    if (tmnData != null) {
      TMN.value = await double.tryParse(tmnData.fcstValue)?.round() ?? 0;
    }

    final tmxData = await
    _weatherDataList2.firstWhereOrNull((data) => data.category == 'TMX');
    if (tmxData != null) {
      TMX.value = await double.tryParse(tmxData.fcstValue)?.round() ?? 0;
    }

    final skyData = await
    _weatherDataList2.firstWhereOrNull((data) => data.category == 'SKY');
    if (skyData != null) {
      SKY.value = await int.tryParse(skyData.fcstValue) ?? 0;
    }

    final rehData = await
    _weatherDataList.firstWhereOrNull((data) => data.category == 'REH');
    if (rehData != null) {
      REH.value = await int.tryParse(rehData.obsrValue) ?? 0;
    }

    WindChill.value =  await double.parse((13.12 + 0.6215 * T1H.value - 11.37 * pow(WSD.value, 0.16) + 0.3965 * T1H.value * pow(WSD.value, 0.16)).toStringAsFixed(1));
    updateCond();
    print("날씨 업데이트 완료");
    }


  void updateCond() {
    if (PTY.value == 0) {
      if (SKY.value == 1) {
        COND.value = "맑음";
      } else if (SKY.value == 3) {
        COND.value = "구름많음";
      } else if (SKY.value == 4) {
        COND.value = "흐림";
      }
    } else if (PTY.value == 1) {
      COND.value = "비";
    } else if (PTY.value == 2) {
      COND.value = "비/눈";
    } else if (PTY.value == 3) {
      COND.value = "눈";
    } else if (PTY.value == 4) {
      COND.value = "소나기";
    }
  }
}
