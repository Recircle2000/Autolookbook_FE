import 'package:flutter/material.dart';

SnackBar ErrorSnackBar(errorMessage) {
  return SnackBar(
    backgroundColor: Colors.red[400], // SnackBar의 배경색
    duration: Duration(seconds: 2),
    content: Text("이메일 또는 비밀번호가 일치하지 않습니다."),
    action: SnackBarAction(
      label: "Done",
      textColor: Colors.white,
      onPressed: () {},
    ),
  );
}

SnackBar emailErrorSnackBar() {
  return SnackBar(
    backgroundColor: Colors.red[400], // SnackBar의 배경색
    duration: Duration(seconds: 2),
    content: Text("이메일의 형식이 올바르지 않습니다."),
    action: SnackBarAction(
      label: "Done",
      textColor: Colors.white,
      onPressed: () {},
    ),
  );
}

SnackBar passwordImptySnackBar() {
  return SnackBar(
    backgroundColor: Colors.red[400], // SnackBar의 배경색
    duration: Duration(seconds: 2),
    content: Text("비밀번호를 입력해주세요."),
    action: SnackBarAction(
      label: "Done",
      textColor: Colors.white,
      onPressed: () {},
    ),
  );
}

SnackBar loginCompleteSnackBar() {
  return SnackBar(
    backgroundColor: Colors.blue[400], // SnackBar의 배경색
    duration: Duration(seconds: 2),
    content: Text("로그인 성공"),
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