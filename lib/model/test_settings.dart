import 'package:klearn/model/test_enum.dart';

class TestSettings {
  TestType testType;
  int numOfQuestions;
  bool isTimeBoxed;
  int testLength; //in minutes

  TestSettings(
      {this.testType,
      this.numOfQuestions,
      this.isTimeBoxed = false,
      this.testLength = 0});
}
