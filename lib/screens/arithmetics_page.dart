import 'package:flutter/material.dart';
import 'package:klearn/model/arithmetic_form_model.dart';
import 'package:klearn/model/arithmetic_test_settings.dart';
import 'package:klearn/widgets/arithmetics_questions.dart';
import 'package:klearn/widgets/side_drawer.dart';

class ArithmeticsPage extends StatelessWidget {
  final ArithmeticTestSettings settings;
  ArithmeticsPage({this.settings});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arithmetic Questions'),
      ),
      body: Container(
          child: ArithmeticsQuestions(
              settings: settings != null
                  ? settings
                  : ArithmeticFormModel().toSettings())),
      drawer: SideDrawer(),
    );
  }
}
