class UploadClothingItem {
  final String category;
  final String color;

  UploadClothingItem({required this.category, required this.color});

  factory UploadClothingItem.fromJson(Map<String, dynamic> json) {
    return UploadClothingItem(
      category: json['category'],
      color: json['color'],
    );
  }
}