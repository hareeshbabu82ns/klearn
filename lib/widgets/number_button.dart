// Copyright (C) 2018 Alberto Varela Sánchez <alberto@berriart.com>
// Use of this source code is governed by the version 3 of the
// GNU General Public License that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:klearn/utils/responsive.dart';

typedef NumcolButtonPressed();

class NumcolButton extends StatelessWidget {
  NumcolButton(
      {Key key,
      @required this.color,
      @required this.text,
      @required this.onPressed})
      : super(key: key);

  final NumcolButtonPressed onPressed;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    var fontSize = Responsive.getValue(context, 18.0, 26.0, 32.0);
    var style = TextStyle(
        color: Colors.white, fontSize: fontSize, fontFamily: 'RobotoMono');
    var buttonColor = color;
    var buttonDarkColor = Colors.grey[500];
    var borderColor = BorderSide(
      color: buttonColor,
      width: 3.0,
    );
    var borderDarkColor = BorderSide(
      color: buttonDarkColor,
      width: 3.0,
    );
    return Center(
      child: InkWell(
        // this is the one you are looking for..........
        onTap: () => onPressed(),
        child: Container(
          //width: 50.0,
          //height: 50.0,
          margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
          padding: EdgeInsets.all(
              15.0), //I used some padding without fixed width and height
          decoration: BoxDecoration(
            shape: BoxShape
                .circle, // You can use like this way or like the below line
            //borderRadius:  BorderRadius.circular(30.0),
            color: color,
          ),
          child: Text(
            text,
            style: style,
          ), // You can add a Icon instead of text also, like below.
          //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
        ), //............
      ),
    );
    // return GestureDetector(
    //   onTapDown: (details) {
    //     onPressed();
    //   },
    //   child: Container(
    //     child: Center(
    //       child: Stack(
    //         children: [
    //           Positioned(
    //             top: 2.0,
    //             left: 2.0,
    //             child: Text(
    //               text,
    //               style: style.copyWith(color: Colors.black.withOpacity(0.4)),
    //             ),
    //           ),
    //           Container(
    //             padding: const EdgeInsets.all(1.0),
    //             child: Text(text, style: style),
    //           ),
    //         ],
    //       ),
    //     ),
    //     decoration: BoxDecoration(
    //       // borderRadius: BorderRadius.circular(45),
    //       color: buttonColor,
    //       border: Border(
    //         top: borderColor,
    //         left: borderColor,
    //         bottom: borderDarkColor,
    //         right: borderDarkColor,
    //       ),
    //     ),
    //   ),
    // );
  }
}
