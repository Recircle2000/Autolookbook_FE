class WeatherData {
  final String baseDate;
  final String baseTime;
  final String category;
  final int nx;
  final int ny;
  final String obsrValue;

  WeatherData({
    required this.baseDate,
    required this.baseTime,
    required this.category,
    required this.nx,
    required this.ny,
    required this.obsrValue,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      baseDate: json['baseDate'],
      baseTime: json['baseTime'],
      category: json['category'],
      nx: json['nx'],
      ny: json['ny'],
      obsrValue: json['obsrValue'],
    );
  }
}