import 'package:klearn/model/arithmetic_operation_enum.dart';
import 'package:klearn/model/test_enum.dart';
import 'package:klearn/model/test_settings.dart';

class ArithmeticTestSettings extends TestSettings {
  int maxDigits;
  int maxNumber;
  List<ArithmeticOperation> operations;
  ArithmeticTestSettings(
      {this.operations,
      this.maxDigits = 2,
      this.maxNumber = 0,
      numOfQuestions,
      isTimeBoxed = false,
      testLength = 0})
      : super(
            testType: TestType.ARITHMETICS,
            numOfQuestions: numOfQuestions,
            isTimeBoxed: isTimeBoxed,
            testLength: testLength);
}
