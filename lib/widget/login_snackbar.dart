import 'package:flutter/material.dart';

SnackBar emailErrorSnackBar() {
  return SnackBar(
    backgroundColor: Colors.red[400], // SnackBar의 배경색
    duration: Duration(seconds: 2),
    content: Text("입력한 이메일의 형식이 옳지 않습니다."),
    action: SnackBarAction(
      label: "Done",
      textColor: Colors.white,
      onPressed: () {},
    ),
  );
}

SnackBar passwordErrorSnackBar() {
  return SnackBar(
    backgroundColor: Colors.red[400], // SnackBar의 배경색
    duration: Duration(seconds: 2),
    content: Text("입력한 암호가 서로 일치하지 않습니다"),
    action: SnackBarAction(
      label: "Done",
      textColor: Colors.white,
      onPressed: () {},
    ),
  );
}

SnackBar inputCheckSnackBar(bool response) {
  if (response) {
    return SnackBar(
      backgroundColor: Colors.blue[400], // SnackBar의 배경색
      duration: Duration(seconds: 2),
      content: Text("사용 가능합니다"),
      action: SnackBarAction(
        label: "Done",
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
  } else {
    return SnackBar(
      backgroundColor: Colors.red[400], // SnackBar의 배경색
      duration: Duration(seconds: 2),
      content: Text("다른 이용자가 사용중입니다"),
      action: SnackBarAction(
        label: "Done",
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
  }
}