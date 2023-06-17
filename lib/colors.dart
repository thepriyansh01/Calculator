import 'package:flutter/material.dart';

bool isDarkTheme = true;

Color getOperatorColor() {
  return isDarkTheme
      ? const Color.fromARGB(255, 203, 235, 24)
      : const Color.fromRGBO(139, 195, 74, 1);
}

Color getTextColor() {
  return isDarkTheme ? Colors.white : Colors.black;
}

Color getBgColor() {
  return isDarkTheme ? Colors.black : Colors.white;
}

Color getDullColor() {
  return isDarkTheme
      ? const Color.fromRGBO(255, 255, 255, 0.6)
      : const Color.fromRGBO(0, 0, 0, 0.6);
}
