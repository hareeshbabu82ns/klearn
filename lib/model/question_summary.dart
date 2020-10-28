import 'package:klearn/model/answer.dart';
import 'package:klearn/model/question.dart';

class QuestionSummary {
  Question question;
  Answer answer;
  Duration duration;
  QuestionSummary({this.question, this.answer, this.duration});
}
