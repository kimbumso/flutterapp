import 'package:flutter/widgets.dart';
import 'package:flutter_app/screens/chat/view/view.dart';
import 'package:flutter_app/screens/login/view/view.dart';
import 'package:flutter_app/screens/quiz/view/view.dart';
import 'package:flutter_app/screens/themestock/view/view.dart';

class HomeList {
  HomeList({this.navigateScreen, this.imagePath = '', this.title = ''});

  Widget navigateScreen;
  String imagePath;
  String title;

  static List<HomeList> homeList = [
    HomeList(
      title: '증권 상식 퀴즈',
      imagePath: 'assets/images/cover.jpg',
      navigateScreen: QuizScreen(),
    ),
    HomeList(
      title: '오늘의 추천',
      imagePath: 'assets/images/recommend.jpg',
      navigateScreen: VoteScreen(),
    ),
    HomeList(
      title: '로그인 하러 가기',
      imagePath: 'assets/images/login.jpg',
      navigateScreen: LoginScreen(),
    ),
  ];
}

class HomeListGold {
  HomeListGold({this.navigateScreen, this.imagePath = '', this.title = ''});

  Widget navigateScreen;
  String imagePath;
  String title;

  static List<HomeListGold> homeList = [
    HomeListGold(
      title: '증권 상식 퀴즈',
      imagePath: 'assets/images/cover.jpg',
      navigateScreen: QuizScreen(),
    ),
    HomeListGold(
      title: '증권 상식 퀴즈 test',
      imagePath: 'assets/images/cover.jpg',
      navigateScreen: QuizScreen2(),
    ),
    HomeListGold(
      title: '오늘의 추천',
      imagePath: 'assets/images/recommend.jpg',
      navigateScreen: VoteScreen(),
    ),
    HomeListGold(
      title: '로그인 유저 전용',
      imagePath: 'assets/images/login.jpg',
      navigateScreen: LoginScreen(),
    ),
    HomeListGold(
      title: '채팅',
      imagePath: 'assets/images/supportIcon.png',
      navigateScreen: ChatHomeScreen(),
    ),
    HomeListGold(
      title: '테마 리스트',
      imagePath: 'assets/images/bar-chart.png',
      navigateScreen: StockHomeScreen(),
    ),
    HomeListGold(
      title: '급등주 리스트',
      imagePath: 'assets/images/jumpup.png',
      navigateScreen: StockHomeScreen(),
    ),
    HomeListGold(
      title: '코인 리스트',
      imagePath: 'assets/images/coin.png',
      navigateScreen: StockHomeScreen(),
    ),
    HomeListGold(
      title: '환율 리스트',
      imagePath: 'assets/images/exchangerate.png',
      navigateScreen: StockHomeScreen(),
    ),
    HomeListGold(
      title: '뉴스 리스트',
      imagePath: 'assets/images/news.png',
      navigateScreen: StockHomeScreen(),
    ),
    HomeListGold(
      title: '세력 분석',
      imagePath: 'assets/images/graph.png',
      navigateScreen: StockHomeScreen(),
    ),
    HomeListGold(
      title: '유용한 사이트',
      imagePath: 'assets/images/ThemeStock.jpg',
      navigateScreen: StockHomeScreen(),
    ),
    HomeListGold(
      title: '적중 내역',
      imagePath: 'assets/images/hitlist.png',
      navigateScreen: StockHomeScreen(),
    ),
  ];
}
