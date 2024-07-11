class Clothes {
  final int? clothesId; // Made nullable to accommodate auto-increment
  final DateTime clothesCreateDate;
  final DateTime clothesLastFitDate;
  final String? clothesCategory;
  final String clothesImage; // Assuming base64 representation for binary data
  final int? clothesCount;
  final List<String> clothesScore; // Assuming serialized JSON or similar
  final String? userId;
  final String? clothesColor;

  Clothes({
    this.clothesId,
    required this.clothesCreateDate,
    required this.clothesLastFitDate,
    this.clothesCategory,
    required this.clothesImage,
    this.clothesCount,
    required this.clothesScore,
    this.userId,
    this.clothesColor,
  });

  factory Clothes.fromJson(Map<String, dynamic> json) {
    return Clothes(
      clothesId: json['Clothes_Id'],
      clothesCreateDate: DateTime.parse(json['Clothes_Create_Date']),
      clothesLastFitDate: DateTime.parse(json['Clothes_LastFit_Date']),
      clothesCategory: json['Clothes_Category'],
      clothesImage: json['Clothes_Image'],
      clothesCount: json['Clothes_Count'],
      clothesScore: List<String>.from(json['Clothes_Score']),
      userId: json['User_Id'],
      clothesColor: json['Clothes_Color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Clothes_Id': clothesId,
      'Clothes_Create_Date': clothesCreateDate.toIso8601String(),
      'Clothes_LastFit_Date': clothesLastFitDate.toIso8601String(),
      'Clothes_Category': clothesCategory,
      'Clothes_Image': clothesImage,
      'Clothes_Count': clothesCount,
      'Clothes_Score': clothesScore,
      'User_Id': userId,
      'Clothes_Color': clothesColor,
    };
  }
}