import 'package:flutter_app/domain/themestock/src/models/models.dart';

import 'package:web_scraper/web_scraper.dart';
import 'dart:convert';

class ThemestockProvider {
  // final String _dataPath = "https://finance.naver.com/sise/theme.nhn";

  final webScraper = WebScraper('https://finance.naver.com');
  List<ThemeStock> themeStockList;

  Future<List<ThemeStock>> loadThemeData() async {
    if (await webScraper.loadWebPage('/sise/theme.nhn?&page=1')) {
      List<Map<String, dynamic>> stockNames =
          webScraper.getElement('td.col_type1 > a', []);

      List<Map<String, dynamic>> ratesDays =
          webScraper.getElement('td.col_type2 > span', []);

      List<Map<String, dynamic>> ratesAverages =
          webScraper.getElement('td.col_type3 > span', []);

      // naver 증권데이터는 ISO-8859-1를 사용
      // themeStockList =
      //     parseTheme(cp949.decode(webScraper.getPageContent().codeUnits));

      var themeList = [
        webScraper.getElement('td.col_type1 > a', []),
        webScraper.getElement('td.col_type2 > span', []),
        webScraper.getElement('td.col_type3 > span', []),
      ];

      themeStockList =
          parseTheme(themeList, ['stockName', 'ratesDay', 'ratesAverage']);

      return themeStockList;
    }
    //connect to flutter jobs web site
    // http.Response response = await http.get(_dataPath);

    // if (response.statusCode == 200) {
    //   // 만약 서버가 OK 응답을 반환하면, JSON을 파싱합니다.
    //   //parse and extract the data from the web site
    //   dom.Document document = parser.parse(utf8.decode(response.bodyBytes));

    //   print('document 1 : ${document.body}');

    //   document.getElementsByTagName('tr').forEach((child) {
    //     themeStockList.add(ThemeStock(
    //       stockName: child.getElementsByTagName('a').first.text,
    //       ratesDay: child.getElementsByTagName('th').last.text,
    //       ratesAverage: child.getElementsByTagName('th')[2].text,
    //     ));
    //   });

    //   for (int i = 0; i < themeStockList.length; i++) {
    //     print('temedata ${i} : ${themeStockList[i]}');
    //   }

    //   return themeStockList;
    // } else {
    //   // 만약 응답이 OK가 아니면, 에러를 던집니다.
    //   throw Exception('Failed to load post');
    // }
    // }
    // Future<Stream<Theme>> loadThemeData() async {
    //   final response = await http.get(_dataPath);
    //   if (response.statusCode == 200) {
    //     // 만약 서버가 OK 응답을 반환하면, JSON을 파싱합니다.
    //     var _themedata = response;
    //     print("theme.data : ${_themedata.body}");
    //     return null;
    //   } else {
    //     // 만약 응답이 OK가 아니면, 에러를 던집니다.
    //     throw Exception('Failed to load post');
    //   }
  }
}
