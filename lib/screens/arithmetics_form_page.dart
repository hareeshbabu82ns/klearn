import 'package:flutter/material.dart';
import 'package:klearn/widgets/arithmetics_setup_form.dart';
import 'package:klearn/widgets/side_drawer.dart';

class ArithmeticsFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arithmetics'),
      ),
      body: Container(child: ArithmeticsForm()),
      drawer: SideDrawer(),
    );
  }
}
