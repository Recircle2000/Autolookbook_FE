import 'package:get/get.dart';
import '../views/login_view.dart';
import '../views/nav_view.dart';
import '../views/settings_view.dart';
import '../views/add_clothes/add_clothes_view.dart';
import '../views/register_view.dart';  // 추가

class AppRoutes {
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const SETTINGS = '/settings';
  static const ADD_CLOTHES = '/add-clothes';
  static const REGISTER = '/register';

  static final routes = [
    GetPage(name: LOGIN, page: () => LoginView()),
    GetPage(name: HOME, page: () => NavView()),
    GetPage(name: ADD_CLOTHES, page: () => AddClothesView()),
    GetPage(name: SETTINGS, page: () => SettingsView()),
    GetPage(name: REGISTER, page: () => RegisterView()),
  ];
}
