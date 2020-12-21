import 'package:flutter/widgets.dart';
import 'package:flutter_app/screens/login/view/view.dart';
import 'package:flutter_app/screens/quiz/view/view.dart';

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
