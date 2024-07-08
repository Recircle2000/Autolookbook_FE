class ClothingItem {
  final String category;
  //final String color;

  ClothingItem({required this.category});

  factory ClothingItem.fromJson(Map<String, dynamic> json) {
    return ClothingItem(
      category: json['category'],
      // color: json['color'],
    );
  }
}