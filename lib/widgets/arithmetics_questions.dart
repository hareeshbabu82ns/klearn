import 'package:flutter/widgets.dart';
import 'package:get/instance_manager.dart';
import 'package:klearn/model/arithmetic_answer.dart';
import 'package:flutter/material.dart';
import 'package:klearn/model/arithmetic_question.dart';
import 'package:klearn/model/arithmetic_test_settings.dart';
import 'package:klearn/model/test_model.dart';
import 'package:klearn/screens/arithmetics_summary_page.dart';
import 'package:klearn/utils/responsive.dart';
// import 'package:klearn/widgets/count_down_timer.dart';
import 'package:klearn/widgets/number_button.dart';

class ArithmeticsQuestions extends StatefulWidget {
  final ArithmeticTestSettings settings;
  ArithmeticsQuestions({this.settings});
  @override
  _ArithmeticsQuestionsState createState() =>
      _ArithmeticsQuestionsState(settings: settings);
}

class _ArithmeticsQuestionsState extends State<ArithmeticsQuestions> {
  final ArithmeticTestSettings settings;
  TestModel _testModel;
  ArithmeticQuestion _currentQuestion;
  ArithmeticAnswer _currentAnswer;
  _ArithmeticsQuestionsState({this.settings}) {
    _testModel = TestModel(id: 1, settings: settings);
    _currentQuestion = _testModel.getNextQuestion();
    _currentAnswer = ArithmeticAnswer(answer: 0);
  }

  Widget _buildButtonColumn(
      Color color, IconData icon, String label, Function onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            Container(
              margin: const EdgeInsets.only(top: 8),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateAnswer({String text}) {
    int newAnswer = _currentAnswer.answer;
    switch (text) {
      case '<':
        newAnswer = (newAnswer / 10).floor();
        break;
      case '-':
        newAnswer *= -1;
        break;
      default:
        newAnswer *= 10;
        newAnswer += int.parse(text);
    }
    setState(() {
      _currentAnswer.answer = newAnswer;
    });
  }

  void goNext() {
    _testModel.addAnswerSummary(answer: _currentAnswer);
    final question = _testModel.getNextQuestion();
    if (question != null)
      setState(() {
        _currentQuestion = question;
        _currentAnswer =
            (_testModel.summary.length > _testModel.currentQuestion - 1)
                ? _testModel.summary[_testModel.currentQuestion - 1].answer
                : ArithmeticAnswer(answer: 0);
      });
    else
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => ArithmeticsSummaryPage(
                  summary: _testModel.summary,
                )),
      );
    // Scaffold.of(context)
    //     .showSnackBar(SnackBar(content: Text('No more Questions')));
  }

  void goBack() {
    _testModel.addAnswerSummary(answer: _currentAnswer);
    final question = _testModel.getPreviousQuestion();
    if (question != null)
      setState(() {
        _currentQuestion = question;
        _currentAnswer =
            _testModel.summary[_testModel.currentQuestion - 1].answer;
      });
  }

  @override
  Widget build(BuildContext context) {
    var padding = Responsive.getValue(context, 16.0, 18.0, 32.0);
    var fontSize = Responsive.getValue(context, 18.0, 24.0, 32.0);
    Color color = Theme.of(context).primaryColor;
    Widget titleSection = Container(
      padding: EdgeInsets.only(bottom: padding),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Q: ${_testModel.currentQuestion}',
                    style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'LemonMilk'),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.timelapse,
            color: Colors.blueAccent[500],
          ),
        ],
      ),
    );
    Widget numberPad = Container(
      padding: EdgeInsets.only(top: padding),
      child: Card(
        margin: EdgeInsets.all(padding),
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              NumcolButton(
                color: color,
                onPressed: () => {updateAnswer(text: '1')},
                text: '1',
              ),
              NumcolButton(
                color: color,
                onPressed: () => {updateAnswer(text: '2')},
                text: '2',
              ),
              NumcolButton(
                color: color,
                onPressed: () => {updateAnswer(text: '3')},
                text: '3',
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              NumcolButton(
                color: color,
                onPressed: () => {updateAnswer(text: '4')},
                text: '4',
              ),
              NumcolButton(
                color: color,
                onPressed: () => {updateAnswer(text: '5')},
                text: '5',
              ),
              NumcolButton(
                color: color,
                onPressed: () => {updateAnswer(text: '6')},
                text: '6',
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              NumcolButton(
                color: color,
                onPressed: () => {updateAnswer(text: '7')},
                text: '7',
              ),
              NumcolButton(
                color: color,
                onPressed: () => {updateAnswer(text: '8')},
                text: '8',
              ),
              NumcolButton(
                color: color,
                onPressed: () => {updateAnswer(text: '9')},
                text: '9',
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              NumcolButton(
                color: color,
                onPressed: () => {updateAnswer(text: '-')},
                text: '-',
              ),
              NumcolButton(
                color: color,
                onPressed: () => {updateAnswer(text: '0')},
                text: '0',
              ),
              NumcolButton(
                color: color,
                onPressed: () => {updateAnswer(text: '<')},
                text: '<',
              ),
            ],
          )
        ]),
      ),
    );
    Widget bottomSection = Container(
      padding: EdgeInsets.only(top: padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(
              color,
              Icons.clear,
              'CLEAR',
              () => {
                    setState(() {
                      _currentAnswer = ArithmeticAnswer(answer: 0);
                    })
                  }),
          _buildButtonColumn(
              color,
              Icons.check,
              'CHECK',
              () => {
                    if (_currentQuestion.validateAnswer(_currentAnswer))
                      {
                        Scaffold.of(context)
                            .showSnackBar(SnackBar(content: Text('Correct')))
                      }
                    else
                      {
                        Scaffold.of(context)
                            .showSnackBar(SnackBar(content: Text('Wrong')))
                      }
                  }),
          _buildButtonColumn(color, Icons.navigate_next, 'NEXT', goNext),
        ],
      ),
    );
    Widget questionSection = Expanded(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(child: child, scale: animation);
        },
        child: Dismissible(
          key: ValueKey<int>(_testModel.currentQuestion),
          confirmDismiss: (direction) {
            if (direction == DismissDirection.endToStart) {
              return Future.value(true);
            } else if (direction == DismissDirection.startToEnd) {
              return Future.value(_testModel.currentQuestion > 1);
            }
            return Future.value(false);
          },
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              goNext();
            } else if (direction == DismissDirection.startToEnd) {
              goBack();
            }
          },
          child: QuestionCard(
            key: ValueKey<int>(_testModel.currentQuestion),
            settings: settings,
            question: _currentQuestion,
            answer: _currentAnswer,
          ),
        ),
      ),
    );
    final isLargeTablet = Responsive.getValue(context, false, false, true);
    return isLargeTablet
        ? Container(
            padding: EdgeInsets.all(padding),
            child: Column(
              children: <Widget>[
                titleSection,
                Row(
                  children: [questionSection, numberPad],
                ),

                // isLargeTablet ? null : questionSection,
                // isLargeTablet ? null : numberPad,
                // isLargeTablet
                //     ? Row(
                //         children: [questionSection, numberPad],
                //       )
                //     : null,
                // numberGridPad,
                // bottomSection,
              ],
            ),
          )
        : Container(
            padding: EdgeInsets.all(padding),
            child: Column(
              children: <Widget>[
                titleSection,
                questionSection,
                numberPad,
                // numberGridPad,
                // bottomSection
              ],
            ),
          );
  }
}

class QuestionCard extends StatefulWidget {
  final ArithmeticTestSettings settings;
  final ArithmeticQuestion question;
  final ArithmeticAnswer answer;
  QuestionCard({Key key, this.settings, this.question, this.answer})
      : super(key: key);
  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  @override
  Widget build(BuildContext context) {
    // var cardWidth = Responsive.getValue(context, 250.0, 300.0, 500.0);
    Size screenSize = MediaQuery.of(context).size;
    // var padding = Responsive.getValue(context, 16.0, 18.0, 32.0);
    var fontSize = Responsive.getValue(context, 18.0, 24.0, 32.0);
    var style = TextStyle(
        color: Colors.blueAccent, fontSize: fontSize, fontFamily: 'RobotoMono');

    List<Widget> buildQuestion() {
      final list = List<Widget>();
      for (var i = 0; i < widget.question.numbers.length; i++) {
        final num = widget.question.numbers[i];
        var numStr = '$num';
        if (numStr.length < widget.settings.maxDigits) {
          //pad extra spaces in front of the number
          var spaces = widget.settings.maxDigits - numStr.length;
          for (var i = 0; i < spaces; i++) {
            numStr = ' ' + numStr;
          }
        }
        if (widget.question.numbers.length == i + 1)
          list.add(Text(
              ' ${ArithmeticQuestion.getOperationString(widget.question.operation)} $numStr   ',
              style: style));
        else
          list.add(Text('   $numStr   ', style: style));
      }
      var lineStr = '';
      for (var i = 0; i < widget.settings.maxDigits + 6; i++) {
        lineStr = '-' + lineStr;
      }
      list.add(Text(lineStr, style: style));

      var numStr = widget.answer.answer != 0 ? '${widget.answer.answer}' : '';
      var spaces = widget.settings.maxDigits - numStr.length;
      for (var i = 0; i < spaces; i++) {
        numStr = ' ' + numStr;
      }
      list.add(Text('   $numStr   ', style: style));

      list.add(Text(lineStr, style: style));
      return list;
    }

    return Card(
      color: Colors.transparent,
      elevation: 4.0,
      child: Container(
        width: screenSize.width / 1.7,
        // height: screenSize.height / 1.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[...buildQuestion()],
        ),
      ),
    );
  }
}
