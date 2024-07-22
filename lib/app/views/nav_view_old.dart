import 'package:flutter/material.dart';

import 'settings_view.dart';
import 'add_clothes/add_clothes_view.dart';
import 'main_view.dart';
import 'test_view.dart';
import 'check_clothes_view.dart';

class NavView extends StatefulWidget {
  @override
  _NavViewState createState() => _NavViewState();
}

class _NavViewState extends State<NavView> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    MainView(),
    CheckClothesView(),
    AddClothesView(),
    SettingsView(),
    TestView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // 이 부분을 추가
        selectedItemColor: Colors.black,
        // 선택된 아이템의 색상
        unselectedItemColor: Colors.grey,
        // 선택되지 않은 아이템의 색상
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_sharp),
            label: '옷 확인',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '환경 설정',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.adb),
            label: '테스트',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
