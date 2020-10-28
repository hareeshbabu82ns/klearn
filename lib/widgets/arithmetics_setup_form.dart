// Create a Form widget.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klearn/model/arithmetic_form_model.dart';
import 'package:klearn/screens/arithmetics_page.dart';
import 'package:klearn/widgets/arithmetics_questions.dart';

class ArithmeticsForm extends StatefulWidget {
  @override
  ArithmeticsFormState createState() {
    return ArithmeticsFormState();
  }
}

class ArithmeticsFormState extends State<ArithmeticsForm> {
  final _formKey = GlobalKey<FormState>();
  final _data = ArithmeticFormModel();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return new Container(
      padding: new EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
              child: Text('Operations'),
            ),
            SwitchListTile(
                title: const Text('Additions'),
                value: _data.addition,
                onChanged: (bool val) => setState(() => _data.addition = val)),
            SwitchListTile(
                title: const Text('Substractions'),
                value: _data.substraction,
                onChanged: (bool val) =>
                    setState(() => _data.substraction = val)),
            SwitchListTile(
                title: const Text('Multiplications'),
                value: _data.multiplication,
                onChanged: (bool val) =>
                    setState(() => _data.multiplication = val)),
            SwitchListTile(
                title: const Text('Divisions'),
                value: _data.division,
                onChanged: (bool val) => setState(() => _data.division = val)),
            TextFormField(
              initialValue: _data.maxDigits.toString(),
              decoration: const InputDecoration(
                icon: const Icon(Icons.format_list_numbered),
                hintText: 'Number of Digits',
                labelText: 'Number of Digits',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter Digits.';
                }
                return null;
              },
              onSaved: (val) =>
                  setState(() => _data.maxDigits = int.tryParse(val)),
            ),
            SwitchListTile(
                title: const Text('By Time'),
                value: _data.timeBoxed,
                onChanged: (bool val) => setState(() => _data.timeBoxed = val)),
            TextFormField(
              initialValue: _data.duration.toString(),
              decoration: const InputDecoration(
                icon: const Icon(Icons.timer),
                hintText: 'Duration (in Min)',
                labelText: 'Duration (in Min)',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter duration.';
                }
                return null;
              },
              onSaved: (val) =>
                  setState(() => _data.duration = int.tryParse(val)),
            ),
            SwitchListTile(
                title: const Text('By Questions'),
                value: _data.quantityBoxed,
                onChanged: (bool val) =>
                    setState(() => _data.quantityBoxed = val)),
            TextFormField(
              initialValue: _data.quantity.toString(),
              decoration: const InputDecoration(
                icon: const Icon(Icons.format_list_numbered),
                hintText: 'Number of Questions',
                labelText: 'Number of Questions',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter Questions.';
                }
                return null;
              },
              onSaved: (val) =>
                  setState(() => _data.quantity = int.tryParse(val)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    // If the form is valid, display a Snackbar.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ArithmeticsPage(
                                settings: _data.toSettings(),
                              )),
                    );
                  }
                },
                child: Text('Start'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
