import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'settings_view.dart';
import 'add_clothes_view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    Text('Main Menu'),
    AddClothesView(),
    SettingsView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메인'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '메인 메뉴',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '옷 추가',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '환경 설정',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
