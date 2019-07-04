import 'package:flutter/material.dart';

// class style default
class Default {
  static Color btnPrimary() {
    return Colors.blue;
  }

  static TextStyle btnPrimaryText(BuildContext context) {
    return Theme.of(context).textTheme.display1.copyWith(
          fontSize: 14,
          color: Colors.white,
          //backgroundColor: Colors.blue[200],
        );
  }

  static Color btnDanger() {
    return Colors.red;
  }

  static TextStyle btnDangerText(BuildContext context) {
    return Theme.of(context).textTheme.display1.copyWith(
          fontSize: 14,
          color: Colors.white,
          //backgroundColor: Colors.red[200],
        );
  }

  static Color btnInfo() {
    return Colors.green;
  }

  static TextStyle btnInfoText(BuildContext context) {
    return Theme.of(context).textTheme.display1.copyWith(
      fontSize: 14,
      color: Colors.green,
      //backgroundColor: Colors.blue[200],
    );
  }

  static TextStyle errorText(BuildContext context) {
    return Theme.of(context).textTheme.display1.copyWith(
      fontSize: 14,
      color: Colors.red,
      //backgroundColor: Colors.red[200],
    );
  }
}

// theme 1
class Theme1 {
  static Color btnPrimary() {
    return Colors.green;
  }

  static TextStyle btnPrimaryText(BuildContext context) {
    return Theme.of(context).textTheme.display1.copyWith(
          fontSize: 14,
          color: Colors.white,
          //backgroundColor: Colors.blue[200],
        );
  }

  static Color btnDanger() {
    return Colors.orange;
  }

  static TextStyle btnDangerText(BuildContext context) {
    return Theme.of(context).textTheme.display1.copyWith(
          fontSize: 14,
          color: Colors.white,
          //backgroundColor: Colors.red[200],
        );
  }
}
