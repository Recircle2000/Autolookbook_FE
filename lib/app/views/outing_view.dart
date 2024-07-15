import 'package:flutter/material.dart';


class OutingView extends StatelessWidget {
  const OutingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('외출하기'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('외출하기 페이지입니다.'),
          ],
        ),
      ),
    );
  }
}
