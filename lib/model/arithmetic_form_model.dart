import 'package:klearn/model/arithmetic_operation_enum.dart';
import 'package:klearn/model/arithmetic_test_settings.dart';

class ArithmeticFormModel {
  bool addition = true;
  bool substraction = true;
  bool multiplication = false;
  bool division = false;

  int maxDigits = 2;
  int maxNumber = 20;

  bool timeBoxed = false;
  int duration = 5;

  bool quantityBoxed = true;
  int quantity = 20;

  ArithmeticTestSettings toSettings() {
    final List<ArithmeticOperation> operations = List();

    if (addition) operations.add(ArithmeticOperation.ADDITION);
    if (substraction) operations.add(ArithmeticOperation.SUBSTRACTION);
    if (multiplication) operations.add(ArithmeticOperation.MULTIPLICATION);
    if (division) operations.add(ArithmeticOperation.DIVISION);

    return ArithmeticTestSettings(
        operations: operations,
        isTimeBoxed: timeBoxed,
        maxDigits: maxDigits,
        maxNumber: maxNumber,
        numOfQuestions: quantity,
        testLength: duration);
  }
}
