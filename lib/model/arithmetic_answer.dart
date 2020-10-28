import 'package:klearn/model/answer.dart';

class ArithmeticAnswer extends Answer {
  int answer;
  ArithmeticAnswer({this.answer});
  String toString() {
    return answer.toString();
  }
}
