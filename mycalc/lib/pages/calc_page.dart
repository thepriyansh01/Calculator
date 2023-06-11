import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:mycalc/colors.dart';


class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  var input = "";
  var output = "";
  var operation = "";
  var hideInput = false;
  double outputSize = 34;
  double outputOpacity = 0.7;
  double btnTextSize = 29;
  double btnPadding = 15;
  double btnMargin = 8;
  double toDegree = 3.14159265358979323846 / 180;
  var isDegree = false;
  var isTrigo = true;

  var openScientific = false;

  bool isBracketBalanced(String expression) {
    var stack = [];

    for (var i = 0; i < expression.length; i++) {
      var char = expression[i];
      if (char == '(') {
        stack.add(char);
      } else if (char == ')') {
        if (stack.isEmpty || stack.last != '(') {
          return false;
        }
        stack.removeLast();
      }
    }

    return stack.isEmpty;
  }

  String completeBrackets(String expression) {
    var stack = [];

    for (var i = 0; i < expression.length; i++) {
      var char = expression[i];
      if (char == '(') {
        stack.add(char);
      } else if (char == ')') {
        if (stack.isEmpty || stack.last != '(') {
          stack.add('(');
        } else {
          stack.removeLast();
        }
      }
    }

    while (stack.isNotEmpty) {
      expression += ')';
      stack.removeLast();
    }

    return expression;
  }

  onClick(value) {
    if (value == "AC") {
      input = "";
      output = "";
    } else if (value == "back" && input.isNotEmpty) {
      input = input.substring(0, input.length - 1);
    } else if (value == "=") {
      if (input.isNotEmpty) {
        var userInput = input;
        userInput = userInput.replaceAll("x", "*");
        userInput = userInput.replaceAll("÷", "/");
        userInput = isDegree
            ? userInput.replaceAll("sin(", "sin($toDegree*")
            : userInput;
        userInput = isDegree
            ? userInput.replaceAll("cos(", "cos($toDegree*")
            : userInput;
        userInput = isDegree
            ? userInput.replaceAll("tan(", "tan($toDegree*")
            : userInput;
        userInput = userInput.replaceAll("π", "3.141592653589793");
        userInput = userInput.replaceAll("e", "2.718281828459045");
        userInput = userInput.replaceAll("√", "sqrt");
        userInput = userInput.replaceAll("log(", "1/ln(10)*ln(");

        if (!isBracketBalanced(userInput)) {
          userInput = completeBrackets(userInput);
        }
        Parser p = Parser();
        Expression expression = p.parse(userInput);
        ContextModel cm = ContextModel();
        var finalValue = expression.evaluate(EvaluationType.REAL, cm);
        output = finalValue.toString();

        if (output.endsWith(".0")) {
          output = output.substring(0, output.length - 2);
        }
        input = output;
        hideInput = true;
        outputSize = 52;
        outputOpacity = 1;
      }
    } else if (value == "modechange") {
      openScientific = !openScientific;
      if (openScientific) {
        btnTextSize = 24;
        btnPadding = 10;
        btnMargin = 5;
      } else {
        btnTextSize = 29;
        btnPadding = 15;
        btnMargin = 8;
      }
    } else {
      if (value == "deg" || value == "rad") {
        isDegree = !isDegree;
      }
      if (value == "2nd") {
        isTrigo = !isTrigo;
      }
      if (value == "back" ||
          value == "modechange" ||
          value == "2nd" ||
          value == "deg" ||
          value == "rad") {
        value = "";
      }
      if (value == "x^y") {
        value = "^";
      }
      if (value == "√x") {
        value = "√(";
      }
      if (value == "x!") {
        value = "!";
      }
      if (value == "1/x") {
        value = "^(-1)";
      }
      if (value == "rem") {
        value = "%";
      }
      if (value == "sin") {
        value = "sin(";
      }
      if (value == "cos") {
        value = "cos(";
      }
      if (value == "tan") {
        value = "tan(";
      }
      if (value == "asin") {
        value = "arcsin(";
      }
      if (value == "acos") {
        value = "arccos(";
      }
      if (value == "atan") {
        value = "arctan(";
      }
      if (value == "log") {
        value = "log(";
      }

      input = input + value;

      hideInput = false;
      outputSize = 34;
      outputOpacity = 0.7;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
              child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  hideInput ? "" : input,
                  style: const TextStyle(fontSize: 48, color: textColor),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  output,
                  style: TextStyle(
                    fontSize: outputSize,
                    color: textColor.withOpacity(outputOpacity),
                  ),
                ),
              ],
            ),
          )),

          //Button Area

          openScientific
              ? Row(children: [
                  button(text: "2nd", textColor: dullColor),
                  isDegree
                      ? button(text: "deg", textColor: dullColor)
                      : button(text: "rad", textColor: dullColor),
                  isTrigo
                      ? button(text: "sin", textColor: dullColor)
                      : button(text: "asin", textColor: dullColor),
                  isTrigo
                      ? button(text: "cos", textColor: dullColor)
                      : button(text: "acos", textColor: dullColor),
                  isTrigo
                      ? button(text: "tan", textColor: dullColor)
                      : button(text: "atan", textColor: dullColor),
                ])
              : Container(),
          openScientific
              ? Row(
                  children: [
                    button(text: "x^y", textColor: dullColor),
                    button(text: "log", textColor: dullColor),
                    button(text: "ln", textColor: dullColor),
                    button(text: "(", textColor: dullColor),
                    button(text: ")", textColor: dullColor),
                  ],
                )
              : Container(),
          Row(
            children: [
              openScientific
                  ? button(text: "√x", textColor: dullColor)
                  : Container(),
              button(text: "AC", textColor: operatorColor),
              button(text: "back", textColor: operatorColor),
              button(text: "rem", textColor: operatorColor),
              button(text: "÷", textColor: operatorColor),
            ],
          ),
          Row(
            children: [
              openScientific
                  ? button(text: "x!", textColor: dullColor)
                  : Container(),
              button(text: "7"),
              button(text: "8"),
              button(text: "9"),
              button(text: "x", textColor: operatorColor),
            ],
          ),
          Row(
            children: [
              openScientific
                  ? button(text: "1/x", textColor: dullColor)
                  : Container(),
              button(text: "4"),
              button(text: "5"),
              button(text: "6"),
              button(text: "-", textColor: operatorColor),
            ],
          ),
          Row(
            children: [
              openScientific
                  ? button(text: "π", textColor: dullColor)
                  : Container(),
              button(text: "1"),
              button(text: "2"),
              button(text: "3"),
              button(text: "+", textColor: operatorColor),
            ],
          ),
          Row(
            children: [
              button(text: "modechange", textColor: operatorColor),
              openScientific ? button(text: "e") : Container(),
              button(text: "0"),
              button(text: "."),
              button(text: "=", bgColor: operatorColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget button({text, textColor = Colors.white, bgColor = buttonColor}) {
    IconData? iconData;
    switch (text) {
      case '+':
        iconData = Icons.add;
        break;
      case '-':
        iconData = Icons.remove;
        break;
      case 'x':
        iconData = Icons.close;
        break;
      case 'back':
        iconData = Icons.backspace_outlined;
        break;
      case 'modechange':
        iconData = Icons.swipe_vertical_sharp;
        break;
      default:
        iconData = null;
    }

    return Expanded(
      child: Container(
        margin: EdgeInsets.all(btnMargin),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            padding: EdgeInsets.all(btnPadding),
            backgroundColor: bgColor,
          ),
          onPressed: () => onClick(text),
          child: iconData != null
              ? Icon(
                  iconData,
                  size: btnTextSize,
                  color: textColor,
                )
              : Text(
                  text,
                  style: TextStyle(
                    fontSize: btnTextSize,
                    color: textColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
        ),
      ),
    );
  }
}
