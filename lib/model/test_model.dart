import 'dart:math';

import 'package:klearn/model/answer.dart';
import 'package:klearn/model/arithmetic_question.dart';
import 'package:klearn/model/arithmetic_test_settings.dart';
import 'package:klearn/model/question.dart';
import 'package:klearn/model/question_summary.dart';
import 'package:klearn/model/test_enum.dart';
import 'package:klearn/model/test_settings.dart';

class TestModel {
  int id;
  TestSettings settings;
  DateTime startTime;
  int elapsedTime;
  bool testEnded = false;
  List<Question> questions = List();
  int currentQuestion = 0;
  List<QuestionSummary> summary = List();

  TestModel({this.id, this.settings}) {
    if (settings.testType == TestType.ARITHMETICS) {
      ArithmeticTestSettings _settings = settings;
      if (settings.numOfQuestions > 0) {
        for (var questionIdx = 0;
            questionIdx < settings.numOfQuestions;
            questionIdx++)
          questions.add(ArithmeticQuestion.generateRandom(
              operations: _settings.operations,
              maxNumber: _settings.maxNumber > 0
                  ? _settings.maxNumber
                  : pow(10, _settings.maxDigits) - 1));
      }
    }
  }

  void addAnswerSummary({Answer answer, Duration duration = Duration.zero}) {
    try {
      final _summary = summary[currentQuestion - 1];
      if (_summary != null) {
        _summary.answer = answer;
        _summary.duration = duration;
      }
    } catch (ex) {
      summary.add(QuestionSummary(
          question: questions[currentQuestion - 1],
          answer: answer,
          duration: duration));
    }
  }

  Question getPreviousQuestion() {
    if (currentQuestion > 0)
      return questions[--currentQuestion - 1];
    else
      return null;
  }

  Question getNextQuestion() {
    if (currentQuestion < settings.numOfQuestions)
      return questions[currentQuestion++];
    else
      return null;
  }
}
