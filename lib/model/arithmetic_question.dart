import 'dart:math';

import 'package:klearn/model/answer.dart';
import 'package:klearn/model/arithmetic_answer.dart';
import 'package:klearn/model/arithmetic_operation_enum.dart';
import 'package:klearn/model/question.dart';

class ArithmeticQuestion extends Question {
  final Random _random = Random();
  final List<int> numbers = new List();
  ArithmeticOperation operation;
  ArithmeticAnswer _answer;

  ArithmeticQuestion({ArithmeticAnswer answer}) : super(answer: answer) {
    this._answer = answer;
  }

  @override
  bool validateAnswer(Answer answer) {
    if (answer is ArithmeticAnswer) {
      return this._answer.answer == answer.answer;
    } else
      return false;
  }

  String toString() {
    String curNum = '';
    for (var i = 0; i < numbers.length; i++) {
      curNum += numbers[i].toString() + ' ';
      if (i != numbers.length - 1)
        curNum += getOperationString(this.operation) + ' ';
    }
    return curNum;
  }

  static String getOperationString(ArithmeticOperation operation) {
    switch (operation) {
      case ArithmeticOperation.ADDITION:
        return '+';
        break;
      case ArithmeticOperation.SUBSTRACTION:
        return '-';
        break;
      case ArithmeticOperation.MULTIPLICATION:
        return '*';
        break;
      case ArithmeticOperation.DIVISION:
        return '/';
        break;
    }
  }

  ArithmeticQuestion.generateRandom(
      {ArithmeticOperation operation,
      List<ArithmeticOperation> operations,
      int maxNumber = 20,
      int count = 2})
      : super(answer: ArithmeticAnswer(answer: 0)) {
    int curNum;
    this._answer = answer;
    if (operation != null)
      this.operation = operation;
    else if (operations == null) {
      this.operation = ArithmeticOperation.ADDITION;
    } else {
      // generate random operation, of given list
      this.operation = operations[_random.nextInt(operations.length)];
    }
    for (var i = 0; i < count; i++) {
      curNum = _random.nextInt(maxNumber);
      curNum = curNum == 0 ? _random.nextInt(maxNumber) : curNum;
      this.numbers.add(curNum);
    }

    if (this.operation == ArithmeticOperation.SUBSTRACTION) {
      this.numbers.sort((a, b) => a < b ? 1 : 0);
    }

    for (var i = 0; i < count; i++) {
      curNum = this.numbers[i];
      if (i == 0)
        _answer.answer = curNum;
      else
        switch (this.operation) {
          case ArithmeticOperation.ADDITION:
            _answer.answer += curNum;
            break;
          case ArithmeticOperation.SUBSTRACTION:
            _answer.answer -= curNum;
            break;
          case ArithmeticOperation.MULTIPLICATION:
            _answer.answer *= curNum;
            break;
          case ArithmeticOperation.DIVISION:
            _answer.answer = (_answer.answer / curNum).floor();
            break;
        }
    }
  }
}
