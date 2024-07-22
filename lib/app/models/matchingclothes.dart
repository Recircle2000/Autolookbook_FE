import 'package:autolookbook/app/models/clothes.dart';

class MatchingClothesModel {
  List<Clothes> tops = [];
  List<Clothes> bottoms = [];
  List<Clothes> outerwear = [];

  void add(Clothes clothes, String category) {
    switch (category) {
      case 'tops':
        tops.add(clothes);
        break;
      case 'bottoms':
        bottoms.add(clothes);
        break;
      case 'outerwear':
        outerwear.add(clothes);
        break;
    }
  }
}