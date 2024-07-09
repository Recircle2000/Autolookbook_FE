import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DateDisplayWidget extends StatefulWidget {
  @override
  _DateDisplayWidgetState createState() => _DateDisplayWidgetState();
}

class _DateDisplayWidgetState extends State<DateDisplayWidget> {
  String formattedDate = '';
  String formattedDay = '';

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko_KR', null).then((_) {
      setState(() {
        DateTime now = DateTime.now();
        formattedDate = DateFormat('M월 d일').format(now); // 날짜 포맷 변경
        formattedDay = DateFormat('E', 'ko_KR').format(now); // 요일 포맷 변경
      });
    });
  }

  @override
Widget build(BuildContext context) {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: "$formattedDay ",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        TextSpan(
          text: "$formattedDate",
          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
        ),
      ],
    ),
  );
}
}