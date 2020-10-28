import 'package:flutter/material.dart';
import 'package:klearn/model/arithmetic_answer.dart';
import 'package:klearn/model/arithmetic_question.dart';
import 'package:klearn/model/question_summary.dart';
import 'package:klearn/screens/arithmetics_form_page.dart';
import 'package:klearn/utils/responsive.dart';
import 'package:klearn/widgets/side_drawer.dart';

class ArithmeticSummaryListItem extends StatelessWidget {
  QuestionSummary summary;
  ArithmeticSummaryListItem({this.summary});

  @override
  Widget build(BuildContext context) {
    final fontSize = Responsive.getValue(context, 18.0, 24.0, 32.0);
    final style = TextStyle(
        color: Colors.blueAccent, fontSize: fontSize, fontFamily: 'RobotoMono');
    return Semantics(
      container: true,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        // color: summary.question.validateAnswer(summary.answer)
        //     ? Colors.green
        //     : Colors.red,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                summary.question.toString(),
                style: style,
              ),
              Text(
                summary.answer.toString() +
                    ' (${summary.question.answer.toString()})',
                style: style,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArithmeticsSummaryPage extends StatelessWidget {
  List<QuestionSummary> summary;
  ArithmeticsSummaryPage({this.summary});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arithmetics Summary'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ArithmeticsFormPage()));
            },
          )
        ],
      ),
      body: Container(
        child: GridView.extent(
          maxCrossAxisExtent: Responsive.getValue(context, 100.0, 150.0, 250.0),
          children: List.generate(
            summary != null ? summary.length : 0,
            (index) {
              final _summary = summary[index];
              return ArithmeticSummaryGridItem(summary: _summary);
            },
          ),
        ),
        // child: ListView.builder(
        //   itemCount: summary != null ? summary.length : 0,
        //   itemBuilder: (BuildContext context, int index) {
        //     final _summary = summary[index];
        //     return ArithmeticSummaryListItem(summary: _summary);
        //   },
        // ),
      ),
      drawer: SideDrawer(),
    );
  }
}

class ArithmeticSummaryGridItem extends StatefulWidget {
  QuestionSummary summary;
  bool showAnswer;
  ArithmeticSummaryGridItem({this.summary, this.showAnswer = false});

  @override
  _ArithmeticSummaryGridItemState createState() =>
      _ArithmeticSummaryGridItemState(showAnswer: this.showAnswer);
}

class _ArithmeticSummaryGridItemState extends State<ArithmeticSummaryGridItem> {
  bool showAnswer;
  _ArithmeticSummaryGridItemState({this.showAnswer = false});
  @override
  Widget build(BuildContext context) {
    final fontSize = Responsive.getValue(context, 18.0, 24.0, 26.0);
    final style = TextStyle(
        color: Colors.blueAccent, fontSize: fontSize, fontFamily: 'RobotoMono');
    ArithmeticQuestion question = widget.summary.question;
    ArithmeticAnswer answer = widget.summary.answer;
    int maxLength = question.numbers.reduce((n1, n2) =>
        n1.toString().length > n2.toString().length
            ? n1.toString().length
            : n2.toString().length);
    maxLength = maxLength > answer.answer.toString().length
        ? maxLength
        : answer.answer.toString().length;
    return InkWell(
      onTap: () => {
        setState(() {
          showAnswer = !showAnswer;
        })
      },
      child: Semantics(
        container: true,
        child: Container(
          height: 90,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: SafeArea(
            top: false,
            bottom: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ...List.generate(question.numbers.length, (index) {
                  var number = question.numbers[index];
                  if (index != question.numbers.length - 1)
                    return Text(
                      number.toString().padLeft(maxLength + 2),
                      style: style,
                    );
                  else
                    return Text(
                      '${ArithmeticQuestion.getOperationString(question.operation)} $number'
                          .toString()
                          .padLeft(maxLength - 2),
                      style: style,
                    );
                }),
                Text(
                  ''.padLeft(maxLength + 6, '-'),
                  style: style,
                ),
                Text(
                  showAnswer
                      ? question.answer.toString().padLeft(maxLength + 2)
                      : answer.toString().padLeft(maxLength + 2),
                  style: style.copyWith(
                      color: widget.summary.question
                              .validateAnswer(widget.summary.answer)
                          ? Colors.green
                          : Colors.red),
                ),
                Text(
                  ''.padLeft(maxLength + 6, '-'),
                  style: style,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
