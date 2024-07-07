import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'settings_view.dart';
import 'add_clothes_view.dart';
import 'main_view.dart';
import '../controllers/location_controller.dart';

class NavView extends StatefulWidget {
  @override
  _NavViewState createState() => _NavViewState();
}

class _NavViewState extends State<NavView> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    MainView(),
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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
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
