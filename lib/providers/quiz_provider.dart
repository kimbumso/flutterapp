import 'package:flutter/widgets.dart';
import 'package:flutter_app/domain/quiz/src/models/models.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class QuizProvider {
  final String _dataPath = "https://bskim01.herokuapp.com/quiz/3/";
  List<Quiz> quizs;

  Future<List<Quiz>> loadQuizData() async {
    final response = await http.get(_dataPath);
    if (response.statusCode == 200) {
      // 만약 서버가 OK 응답을 반환하면, JSON을 파싱합니다.
      quizs = parseQuizs(utf8.decode(response.bodyBytes));
      // print("quizs.length : ${quizs.length}");
      return quizs;
    } else {
      // 만약 응답이 OK가 아니면, 에러를 던집니다.
      throw Exception('Failed to load post');
    }
  }
}
