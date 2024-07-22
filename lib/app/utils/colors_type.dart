class ColorsType {
  static const Map<String, String> colorsType = {
    "white": "흰색",
    "black": "검정색",
    "gray": "회색",
    "silver": "은색",
    "light orange": "연한 주황색",
    "orange": "주황색",
    "yellow": "노란색",
    "pink": "분홍색",
    "light pink": "연한 분홍색",
    "ivory": "아이보리색",
    "beige": "베이지색",
    "khaki": "카키색",
    "light green": "연한 녹색",
    "green": "녹색",
    "cyan": "청록색",
    "olive": "올리브색",
    "light blue": "연한 파란색",
    "blue": "파란색",
    "navy": "남색",
    "light purple": "연한 보라색",
    "purple": "보라색",
    "red purple": "붉은 보라색",
    "light red": "연한 빨간색",
    "red": "빨간색",
    "brown": "갈색",
  };

  static String? getColorssValue(String key) {
    return colorsType[key];
  }
}

class ColorsHEX {
  static const Map<String, String> colorsHEX = {
    "white": "ffffff",
    "black": "000000",
    "gray": "808080",
    "silver": "c0c0c0",
    "light orange": "f5b041",
    "orange": "ffa500",
    "yellow": "ffff00",
    "pink": "ffc0cb",
    "light pink": "ffb6c1",
    "ivory": "fffff0",
    "beige": "f5f5dc",
    "khaki": "f0e68c",
    "light green": "90ee90",
    "green": "008000",
    "cyan": "00ffff",
    "olive": "808000",
    "light blue": "add8e6",
    "blue": "0000ff",
    "navy": "000080",
    "light purple": "d8bfd8",
    "purple": "800080",
    "red purple": "800080",
    "light red": "f08080",
    "red": "ff0000",
    "brown": "a52a2a",
  };
}