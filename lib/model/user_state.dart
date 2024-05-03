import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLoginProvider with ChangeNotifier {
  bool _UserloginState = false;
  // 시작할때 user login 정보 load
  loadUserLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(
        "user state modal shared preferences value : ${prefs.getBool('UserLogin')}");
    if ((prefs.getBool('UserLogin') ?? 0) == 0) {
      //userlogin 값이 존재하지 않을 경우, shredPreferences에 정보 생성
      prefs.setBool('UserLogin', _UserloginState);
    } else {
      //userlogin 값이 존재할 경우
      _UserloginState = prefs.getBool('UserLogin')!;
    }
  }

  // user login state 값 가져오기
  bool get getUserLoginState => _UserloginState;

  setUserLoginStateTrue() {
    _UserloginState = true;
  }

  setUserLoginStateFalse() {
    _UserloginState = false;
  }
}