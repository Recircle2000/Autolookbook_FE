class WeatherData_Nest { // 초단기 실황
  final String baseDate;
  final String baseTime;
  final String category;
  final int nx;
  final int ny;
  final String obsrValue;

  WeatherData_Nest({
    required this.baseDate,
    required this.baseTime,
    required this.category,
    required this.nx,
    required this.ny,
    required this.obsrValue,
  });

  factory WeatherData_Nest.fromJson(Map<String, dynamic> json) {
    return WeatherData_Nest(
      baseDate: json['baseDate'],
      baseTime: json['baseTime'],
      category: json['category'],
      nx: json['nx'],
      ny: json['ny'],
      obsrValue: json['obsrValue'],
    );
  }
}

class WeatherData_Fest { // 초단기 예보
  final String baseDate;
  final String baseTime;
  final String fcstDate;
  final String fcstTime;
  final String category;
  final int nx;
  final int ny;
  final String fcstValue;

  WeatherData_Fest({
    required this.baseDate,
    required this.baseTime,
    required this.fcstDate,
    required this.fcstTime,
    required this.category,
    required this.nx,
    required this.ny,
    required this.fcstValue,
  });

  factory WeatherData_Fest.fromJson(Map<String, dynamic> json) {
    return WeatherData_Fest(
      baseDate: json['baseDate'],
      baseTime: json['baseTime'],
      fcstDate: json['fcstDate'],
      fcstTime: json['fcstTime'],
      category: json['category'],
      nx: json['nx'],
      ny: json['ny'],
      fcstValue: json['fcstValue'],
    );
  }
}

