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