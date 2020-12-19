import 'package:flutter/material.dart';
import 'package:flutter_app/model/api_adapter.dart';
import 'package:flutter_app/screen/screen_quiz.dart';
import 'package:flutter_app/model/model_quiz.dart';
import 'package:flutter_app/screen/screen_vote.dart';
import 'package:flutter_app/screen/screen_Login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Quiz> quizs = [];
  bool isLoading = false;

  _fetchQuizs() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get('https://bskim01.herokuapp.com/quiz/3/');
    if (response.statusCode == 200) {
      setState(() {
        quizs = parseQuizs(utf8.decode(response.bodyBytes));
        isLoading = false;
      });
    } else {
      throw Exception('fail to load');
    }
  }
  // List<Quiz> quizs = [
  //   Quiz.fromMap({
  //     'title': 'test',
  //     'candidates': ['a', 'b', 'c', 'd'],
  //     'answer': 0
  //   }),
  //   Quiz.fromMap({
  //     'title': 'test',
  //     'candidates': ['a', 'b', 'c', 'd'],
  //     'answer': 0
  //   }),
  //   Quiz.fromMap({
  //     'title': 'test',
  //     'candidates': ['a', 'b', 'c', 'd'],
  //     'answer': 0
  //   }),
  // ];

  @override
  Widget build(BuildContext context) {
    // MediaQuery = 현재기기의 여러 상태정보를 알수 있는 method
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    // SafeArea는 기기의 상단 노티 바 부분, 하단 영역을 침범하지 않는 안전한 영역을
    // 잡아주는 위젯
    return WillPopScope(
        onWillPop: () async => false,
        child: SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text('세력을 찾아라!'),
              backgroundColor: Colors.deepPurple,
              leading: Container(),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Image.asset(
                    'images/cover.jpg',
                    width: width * 0.3,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(width * 0.024),
                ),
                Text(
                  '세력주 찾는 앱',
                  style: TextStyle(
                    fontSize: width * 0.065,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' 안내사항입니다.\n 세력 알람받고 성투합시다.',
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.all(width * 0.048),
                ),
                _buildStep(width, '1. 현재 수급이 몰리는 주.'),
                _buildStep(width, '2. 급 등 락 \n 관리자 추천주 '),
                _buildStep(width, '3. 로그인 전용'),
                Padding(
                  padding: EdgeInsets.all(width * 0.048),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: width * 0.036),
                  child: Center(
                    child: ButtonTheme(
                      minWidth: width * 0.8,
                      height: height * 0.05,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: RaisedButton(
                          child: Text(
                            '수급 주 확인',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.deepPurple,
                          onPressed: () {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Row(
                                children: <Widget>[
                                  CircularProgressIndicator(),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: width * 0.036),
                                  ),
                                  Text('lodiang ....'),
                                ],
                              ),
                            ));
                            _fetchQuizs().whenComplete(() {
                              return Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuizScreen(
                                    quizs: quizs,
                                  ),
                                ),
                              );
                            });
                          }),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(width * 0.018),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: width * 0.036),
                  child: Center(
                    child: ButtonTheme(
                      minWidth: width * 0.8,
                      height: height * 0.05,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: RaisedButton(
                          child: Text(
                            '추천 종목 보기',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.deepPurple,
                          onPressed: () {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Row(
                                children: <Widget>[
                                  CircularProgressIndicator(),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: width * 0.036),
                                  ),
                                  Text('lodiang ....'),
                                ],
                              ),
                            ));
                            _fetchQuizs().whenComplete(() {
                              return Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VoteScreen(),
                                ),
                              );
                            });
                          }),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(width * 0.018),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: width * 0.036),
                  child: Center(
                    child: ButtonTheme(
                      minWidth: width * 0.8,
                      height: height * 0.05,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: RaisedButton(
                          child: Text(
                            '로그인 하러 가기',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.deepPurple,
                          onPressed: () {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Row(
                                children: <Widget>[
                                  CircularProgressIndicator(),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: width * 0.036),
                                  ),
                                  Text('lodiang ....'),
                                ],
                              ),
                            ));
                            _fetchQuizs().whenComplete(() {
                              return Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            });
                          }),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget _buildStep(double width, String title) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          width * 0.048, width * 0.024, width * 0.048, width * 0.024),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.check_box,
            size: width * 0.04,
          ),
          Padding(
            padding: EdgeInsets.only(right: width * 0.024),
          ),
          Text(title),
        ],
      ),
    );
  }
}
