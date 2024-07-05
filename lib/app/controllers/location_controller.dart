import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../models/location.dart'; // Import your location model

class LocationController extends GetxController {
  var currentLocation = Location(latitude: 0.0, longitude: 0.0).obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
    print("Location Controller Initialized");
  }

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

    Position position = await Geolocator.getCurrentPosition();
    currentLocation.value = Location(latitude: position.latitude, longitude: position.longitude);

  }
}