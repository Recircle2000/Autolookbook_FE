import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:flutter/material.dart';

import '../widget/home_body_widget.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
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
          /*SalomonBottomBarItem(
            icon: Icon(Icons.search),
            title: Text("Search"),
            selectedColor: Colors.grey,
          ),*/
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("설정"),
            selectedColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}