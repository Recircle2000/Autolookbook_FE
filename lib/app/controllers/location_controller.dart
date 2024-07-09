import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'weather_controller.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../models/location.dart'; // Import your location model
import 'convert_gps.dart';
import 'package:http/http.dart' as http;

class LocationController extends GetxController {
  var currentLocation = Location_lalo(latitude: 0.0, longitude: 0.0).obs;
  var currentLocation_xy = Location_xy(x: 0, y: 0).obs;
  var currentAddress = "".obs;

  /*@override
  void onInit() {
    super.onInit();
    getCurrentLocation();
    print("Location Controller Initialized");
  }*/

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('위치 서비스 없음.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('위치 권한 없음.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    //gps를 통해 받아오는 정보는 위도, 경도
    //기상청에서 필요한 정보는 x,y
    //카카오를 통해 가져오는 주소 정보는 위도, 경도
    //lati(위도) = x, long(경도) = y
    Position position = await Geolocator.getCurrentPosition();
    var positionXYMap = ConvGridGps.gpsToGRID(position.latitude, position.longitude);

    currentLocation.value = Location_lalo(latitude: position.latitude, longitude: position.longitude);
    currentLocation_xy.value = Location_xy(x: positionXYMap['x'], y: positionXYMap['y']);
    String address = await getAddressFromCoordinates(position.latitude, position.longitude);
    currentAddress.value = address;
  }

  Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    String kakaoApiKey = dotenv.get("KAKAO_API_KEY");
    final String url = "https://dapi.kakao.com/v2/local/geo/coord2regioncode.json?input_coord=WGS84&output_coord=WGS84&x=$longitude&y=$latitude";

    final response = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "KakaoAK $kakaoApiKey"},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Kakao API 응답에서 주소 정보 추출 (응답 구조에 따라 경로가 달라질 수 있음)
      final address = data['documents'][0]['region_1depth_name'] + ' ' + data['documents'][0]['region_2depth_name'];
      return address;
    } else {
      throw Exception('Failed to load address');
    }
  }
}