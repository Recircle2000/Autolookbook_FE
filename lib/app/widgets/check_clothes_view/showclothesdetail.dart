import 'dart:convert';

import 'package:autolookbook/app/models/clothes.dart';
import 'package:autolookbook/app/viewmodel/clothes/clothes_delete_viewmodel.dart';
import 'package:autolookbook/app/utils/clothes_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../utils/colors_type.dart';

void showClothesDetailPopup(BuildContext context, Clothes clothes) {
  clothesDeleteViewModel clothesdeleteviewmodel =
      Get.put(clothesDeleteViewModel());
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('옷의 자세한 정보'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              SizedBox(
                width: double.infinity,

                child: Image.memory(
                  base64Decode(clothes.clothesImage),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),
              Text(
                  '카테고리: ${ClothesType.getClothesValue(clothes.clothesCategory ?? 'Unknown')}'),
              Text(
                  '추가된 날짜: ${DateFormat('yyyy-MM-dd').format(clothes.clothesCreateDate)}'),
              Text(
                  '마지막 착용 날짜: ${DateFormat('yyyy-MM-dd').format(clothes.clothesLastFitDate)}'),
              Text('색상: ${ColorsType.getColorssValue(clothes.clothesColor  ?? 'Unknown' ) ?? '알 수 없음'}'),
              Text('착용 횟수: ${clothes.clothesCount?.toString() ?? '알 수 없음'}회'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('닫기'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('삭제',style: TextStyle(color: Colors.redAccent),),
            onPressed: () {
              if (clothes.clothesId != null) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('삭제 확인'),
                      content: Text('정말로 삭제하시겠어요?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('아니오'),
                          onPressed: () {
                            Navigator.of(context)
                                .pop();
                          },
                        ),
                        TextButton(
                          child: Text('예',
                          style: TextStyle(color: Colors.redAccent),),
                          onPressed: () {
                            clothesdeleteviewmodel
                                .deleteClothes(clothes.clothesId!);
                            Navigator.of(context)
                                .pop();
                            Navigator.of(context)
                                .pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ],
      );
    },
  );
}
