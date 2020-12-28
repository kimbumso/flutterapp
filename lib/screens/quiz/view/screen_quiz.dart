import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/config/palette.dart';
import 'package:flutter_app/domain/quiz/src/models/models.dart';
import 'package:flutter_app/providers/quiz_provider.dart';
import 'package:flutter_app/screens/quiz/widgets/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureProvider(
      create: (_) => QuizProvider().loadQuizData(),
      child: Scaffold(
        backgroundColor: Palette.white,
        body: Center(
          child: Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  appBar('quiz_App'),
                  Expanded(
                    child: QuizList(),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget appBar(context) {
    return SizedBox(
      height: AppBar().preferredSize.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Container(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  context,
                  style: TextStyle(
                    fontSize: 22,
                    color: Palette.darkText,
                    fontWeight: FontWeight.w700,
                    backgroundColor: Palette.lightGrey,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class QuizList extends StatelessWidget {
  List<int> _answers = [-1, -1, -1];
  List<bool> _answerState = [false, false, false, false];
  int _currentIndex = 0;
  SwiperController _controller = SwiperController();
  // @override
  // void initState() {
  //   _controller = ScrollController();
  //   _controller.addListener(_scrollListener); //the listener for up and down.
  //   super.initState();
  // }

  // _scrollListener() {
  //   if (_controller.offset >= _controller.position.maxScrollExtent &&
  //       !_controller.position.outOfRange) {
  //     setState(() {
  //       //you can do anything here
  //     });
  //   }
  //   if (_controller.offset <= _controller.position.minScrollExtent &&
  //       !_controller.position.outOfRange) {
  //     setState(() {
  //       //you can do anything here
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var _quizs = Provider.of<List<Quiz>>(context);
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 0, left: 12, right: 12),
          child: Text('FutureProvider Example, users loaded from a File'),
        ),
        Expanded(
          child: _quizs == null
              ? Container(child: CupertinoActivityIndicator(radius: 50.0))
              : ListView.builder(
                  itemCount: _quizs?.length ?? 0,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    // return Container(
                    //   height: 50,
                    //   color: Colors.grey[(index * 200) % 400],
                    //   child: Center(
                    //     child: Text(
                    //         '${_quizs[index].title} ${_quizs[index].answer} | ${_quizs[index].candidates}'),
                    //   ),
                    // );
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.deepPurple),
                      ),
                      width: width * 0.85,
                      height: height * 0.5,
                      child: Swiper(
                        controller: _controller,
                        physics: NeverScrollableScrollPhysics(),
                        loop: false,
                        itemCount: _quizs.length,
                        itemBuilder: (BuildContext context, int index_) {
                          return _buildQuizCard(
                              _quizs[index], width, height, index_);
                        },
                      ),
                    );
                  }),
        ),
      ],
    );
  }

  Widget _buildQuizCard(Quiz quiz, double width, double height, int index) {
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
                  child:
                      _currentIndex == index - 1 ? Text('결과보기') : Text('다음문제'),
                  textColor: Colors.white,
                  color: Colors.deepPurple,
                  onPressed: _answers[_currentIndex] == -1
                      ? null
                      : () {
                          if (_currentIndex == index - 1) {
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
          tap: () {}));
      _children.add(
        Padding(
          padding: EdgeInsets.all(width * 0.024),
        ),
      );
    }
    return _children;
  }
}
