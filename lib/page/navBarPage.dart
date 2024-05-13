import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:flutter/material.dart';

import '../widget/home_body_widget.dart';

class NavBarPage extends StatefulWidget {
  NavBarPage({Key? key}) : super(key: key);

  @override
  State<NavBarPage> createState() => NavBarPageState();
}

class NavBarPageState extends State<NavBarPage> {
  static int bottomNaviationBarIndex = 0;

  setindex(int value) => setState(
        () {
      bottomNaviationBarIndex = value;
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: HomeBodyWidget(
          bottomNavigationBarIndex: bottomNaviationBarIndex,
          setHomeIndex: setindex),
      bottomNavigationBar: SalomonBottomBar(
        margin: EdgeInsets.all(12),
        currentIndex: bottomNaviationBarIndex,
        onTap: (i) => setState(() => bottomNaviationBarIndex = i),
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("메인"),
            selectedColor: Colors.grey,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.add),
            title: Text("옷 추가"),
            selectedColor: Colors.black,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.settings),
            title: Text("설정"),
            selectedColor: Colors.grey,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.bug_report),
            title: Text("디버그 임시페이지"),
            selectedColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}