import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/domain/quiz/src/models/models.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_app/domain/quiz/src/models/model_quiz.dart';
import 'package:flutter_app/screens/quiz/view/view.dart';
import 'package:flutter_app/screens/quiz/widgets/widgets.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class QuizScreen2 extends StatefulWidget {
  List<Quiz> quizs;
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Quiz> quizs = [];
  Future<List<Quiz>> getQuiz() async {
    final response = await http.get('https://bskim01.herokuapp.com/quiz/3/');
    if (response.statusCode == 200) {
      // 만약 서버가 OK 응답을 반환하면, JSON을 파싱합니다.
      return quizs = parseQuizs(utf8.decode(response.bodyBytes));
    } else {
      // 만약 응답이 OK가 아니면, 에러를 던집니다.
      throw Exception('Failed to load post');
    }
  }

  List<int> _answers = [-1, -1, -1];
  List<bool> _answerState = [false, false, false, false];
  int _currentIndex = 0;
  SwiperController _controller = SwiperController();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.deepPurple,
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.deepPurple),
            ),
            width: width * 0.85,
            height: height * 0.7,
            child: Swiper(
              controller: _controller,
              physics: NeverScrollableScrollPhysics(),
              loop: false,
              itemCount: widget.quizs.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildQuizCard(widget.quizs[index], width, height);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuizCard(Quiz quiz, double width, double height) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white),
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, width * 0.024, 0, width * 0.024),
            child: Text(
              'Q' + (_currentIndex + 1).toString() + '.',
              style: TextStyle(
                fontSize: width * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: width * 0.8,
            padding: EdgeInsets.only(top: width * 0.012),
            child: AutoSizeText(
              quiz.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                fontSize: width * 0.048,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Column(
            children: _buildCandidates(width, quiz),
          ),
          Container(
            padding: EdgeInsets.all(width * 0.024),
            child: Center(
              child: ButtonTheme(
                minWidth: width * 0.5,
                height: height * 0.05,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: RaisedButton(
                  child: _currentIndex == widget.quizs.length - 1
                      ? Text('결과보기')
                      : Text('다음문제'),
                  textColor: Colors.white,
                  color: Colors.deepPurple,
                  onPressed: _answers[_currentIndex] == -1
                      ? null
                      : () {
                          if (_currentIndex == widget.quizs.length - 1) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResultScreen(
                                        answers: _answers,
                                        quizs: widget.quizs)));
                          } else {
                            _answerState = [false, false, false, false];
                            _currentIndex += 1;
                            _controller.next();
                          }
                        },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCandidates(double width, Quiz quiz) {
    List<Widget> _children = [];
    for (int i = 0; i < 4; i++) {
      _children.add(CandWidget(
          index: i,
          text: quiz.candidates[i],
          width: width,
          answerState: _answerState[i],
          tap: () {
            setState(() {
              for (int j = 0; j < 4; j++) {
                if (j == i) {
                  _answerState[j] = true;
                  _answers[_currentIndex] = j;
                } else {
                  _answerState[j] = false;
                }
              }
            });
          }));
      _children.add(
        Padding(
          padding: EdgeInsets.all(width * 0.024),
        ),
      );
    }
    return _children;
  }
}
