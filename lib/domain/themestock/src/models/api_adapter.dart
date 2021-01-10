import 'dart:convert';

import 'package:cp949/cp949.dart' as cp949;
import 'package:flutter_app/domain/themestock/src/models/models.dart';

List<ThemeStock> parseTheme(
    List<List<Map<String, dynamic>>> responseBody, List itemNames) {
  List<ThemeStock> elementData = [];
  for (var i = 0; i < responseBody[0].length; i++) {
    elementData.add(
      ThemeStock.fromMap(
        {
          '${itemNames[0]}':
              cp949.decode(responseBody[0][i]['title'].codeUnits).trim(),
          '${itemNames[1]}':
              cp949.decode(responseBody[1][i]['title'].codeUnits).trim(),
          '${itemNames[2]}':
              cp949.decode(responseBody[2][i]['title'].codeUnits).trim(),
        },
      ),
    );
  }

  return elementData;
}
