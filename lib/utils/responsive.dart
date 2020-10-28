import 'package:flutter/material.dart';

class Responsive {
  static T getValue<T>(BuildContext context, T normal, T large, T extralarge) {
    if (MediaQuery.of(context).size.width > 728) {
      return extralarge;
    }

    if (MediaQuery.of(context).size.width > 540) {
      return large;
    }

    return normal;
  }
}
