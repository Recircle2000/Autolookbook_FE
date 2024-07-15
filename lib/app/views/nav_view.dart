import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import 'settings_view.dart';
import 'add_clothes_view.dart';
import 'main_view.dart';
import 'test_view.dart';
import 'check_clothes_view.dart';

class NavView extends StatefulWidget {
  @override
  _NavViewState createState() => _NavViewState();
}

class _NavViewState extends State<NavView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        tabs: [
          PersistentTabConfig(
            screen: MainView(),
            item: ItemConfig(
              icon: Icon(Icons.home),
              title: "Home",
              activeForegroundColor: Colors.black,
            ),
          ),
          PersistentTabConfig(
            screen: CheckClothesView(),
            item: ItemConfig(
              icon: Icon(Icons.account_circle_sharp),
              title: "옷 확인",
              activeForegroundColor: Colors.black,
            ),
          ),
          PersistentTabConfig(
            screen: AddClothesView(),
            item: ItemConfig(
              icon: Icon(Icons.add),
              title: '옷 추가',
              activeForegroundColor: Colors.black,
              iconSize: 30,
            ),
          ),
          PersistentTabConfig(
            screen: SettingsView(),
            item: ItemConfig(
              icon: Icon(Icons.settings),
              title: "환경 설정",
              activeForegroundColor: Colors.black,

            ),
          ),
          PersistentTabConfig(
            screen: TestView(),
            item: ItemConfig(
              icon: Icon(Icons.adb),
              title: "테스트",
              activeForegroundColor: Colors.black,
            ),
          ),
        ],
        navBarBuilder: (navBarConfig) => Style14BottomNavBar(
          navBarConfig: navBarConfig,
        ),
      ),
    );
  }
}
