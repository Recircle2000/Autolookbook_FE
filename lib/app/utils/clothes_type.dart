class ClothesType {
  static const Map<String, String> clothesType = {
    "short_sleeves_knit": "반팔 니트",
    "normalKnit": "니트",
    "short_sleeves": "반팔",
    "fleece_jacket": "후리스",
    "sweatshirt": "맨투맨",
    "padded-coat": "숏패딩",
    "long_sleeve shirt": "긴팔 셔츠",
    "short_sleeve shirt": "반팔 셔츠",
    "hood_zip-up": "후드 집업",
    "Blouson": "블루종",
    "denim_pants": "청바지",
    "long-padded-coat": "롱 패딩",
    "Windbreaker": "바람막이",
    "sleeveless": "민소매",
    "leather jacket": "가죽 재킷",
    "half_pants": "반바지",
    "chino-cotton": "면바지",
    "slacks": "슬랙스",
    "denim-jacket": "데님 재킷",
    "Zip-Up_Knit": "집업 니트",
    "Long_Skirt": "롱 스커트",
    "blazer": "블레이저",
    "hood": "후드",
    "one-piece_dress": "원피스",
    "training-jogger_pants": "트레이닝/조거 팬츠",
    "Short_Skirt": "미니스커트",
    "denim-shirts": "데님 셔츠",
  };

  static String? getClothesValue(String key) {
    return clothesType[key];
  }
}