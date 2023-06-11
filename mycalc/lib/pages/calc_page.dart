import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorApp extends StatefulWidget {
  final Color dullColor;
  final Color operatorColor;
  final Color textColor;
  final Color bgColor;
  const CalculatorApp({
    Key? key,
    required this.textColor,
    required this.operatorColor,
    required this.dullColor,
    required this.bgColor,
  }) : super(key: key);

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  var input = "";
  var output = "";
  var operation = "";
  var hideInput = false;
  var isDegree = false;
  var isTrigo = true;
  List<String> historyArray = [""];
  double toDegree = 3.14159265358979323846 / 180;

  double outputSize = 34;
  double outputOpacity = 0.7;
  double btnTextSize = 29;
  double btnPadding = 15;
  double btnMargin = 8;

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
    var tempUserInput = "";
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

        tempUserInput = userInput;

        Parser p = Parser();
        Expression expression = p.parse(userInput);
        ContextModel cm = ContextModel();
        var finalValue = expression.evaluate(EvaluationType.REAL, cm);
        output = finalValue.toString();

        if (output.endsWith(".0")) {
          output = output.substring(0, output.length - 2);
        }
        tempUserInput = tempUserInput + " = " + output;
        historyArray.add(tempUserInput);
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
      backgroundColor: widget.bgColor,
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            itemCount: historyArray.length - 1,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(historyArray[index + 1]),
                ),
              );
            },
          )),
          inputOutput(),
          keyboard(),
        ],
      ),
    );
  }

  Widget inputOutput() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            hideInput ? "" : input,
            style: TextStyle(fontSize: 48, color: widget.textColor),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            output,
            style: TextStyle(
              fontSize: outputSize,
              color: widget.textColor.withOpacity(outputOpacity),
            ),
          ),
        ],
      ),
    );
  }

  Widget keyboard() {
    return Column(
      children: [
        //Button Area
        openScientific
            ? Row(children: [
                button(
                    text: "2nd",
                    textColor: widget.dullColor,
                    bgColor: widget.bgColor),
                isDegree
                    ? button(
                        text: "deg",
                        textColor: widget.dullColor,
                        bgColor: widget.bgColor)
                    : button(
                        text: "rad",
                        textColor: widget.dullColor,
                        bgColor: widget.bgColor),
                isTrigo
                    ? button(
                        text: "sin",
                        textColor: widget.dullColor,
                        bgColor: widget.bgColor)
                    : button(
                        text: "asin",
                        textColor: widget.dullColor,
                        bgColor: widget.bgColor),
                isTrigo
                    ? button(
                        text: "cos",
                        textColor: widget.dullColor,
                        bgColor: widget.bgColor)
                    : button(
                        text: "acos",
                        textColor: widget.dullColor,
                        bgColor: widget.bgColor),
                isTrigo
                    ? button(
                        text: "tan",
                        textColor: widget.dullColor,
                        bgColor: widget.bgColor)
                    : button(
                        text: "atan",
                        textColor: widget.dullColor,
                        bgColor: widget.bgColor),
              ])
            : Container(),
        openScientific
            ? Row(
                children: [
                  button(
                      text: "x^y",
                      textColor: widget.dullColor,
                      bgColor: widget.bgColor),
                  button(
                      text: "log",
                      textColor: widget.dullColor,
                      bgColor: widget.bgColor),
                  button(
                      text: "ln",
                      textColor: widget.dullColor,
                      bgColor: widget.bgColor),
                  button(
                      text: "(",
                      textColor: widget.dullColor,
                      bgColor: widget.bgColor),
                  button(
                      text: ")",
                      textColor: widget.dullColor,
                      bgColor: widget.bgColor),
                ],
              )
            : Container(),
        Row(
          children: [
            openScientific
                ? button(
                    text: "√x",
                    textColor: widget.dullColor,
                    bgColor: widget.bgColor)
                : Container(),
            button(
                text: "AC",
                textColor: widget.operatorColor,
                bgColor: widget.bgColor),
            button(
                text: "back",
                textColor: widget.operatorColor,
                bgColor: widget.bgColor),
            button(
                text: "rem",
                textColor: widget.operatorColor,
                bgColor: widget.bgColor),
            button(
                text: "÷",
                textColor: widget.operatorColor,
                bgColor: widget.bgColor),
          ],
        ),
        Row(
          children: [
            openScientific
                ? button(
                    text: "x!",
                    textColor: widget.dullColor,
                    bgColor: widget.bgColor)
                : Container(),
            button(
                text: "7",
                textColor: widget.textColor,
                bgColor: widget.bgColor),
            button(
                text: "8",
                textColor: widget.textColor,
                bgColor: widget.bgColor),
            button(
                text: "9",
                textColor: widget.textColor,
                bgColor: widget.bgColor),
            button(
                text: "x",
                textColor: widget.operatorColor,
                bgColor: widget.bgColor),
          ],
        ),
        Row(
          children: [
            openScientific
                ? button(
                    text: "1/x",
                    textColor: widget.dullColor,
                    bgColor: widget.bgColor)
                : Container(),
            button(
                text: "4",
                textColor: widget.textColor,
                bgColor: widget.bgColor),
            button(
                text: "5",
                textColor: widget.textColor,
                bgColor: widget.bgColor),
            button(
                text: "6",
                textColor: widget.textColor,
                bgColor: widget.bgColor),
            button(
                text: "-",
                textColor: widget.operatorColor,
                bgColor: widget.bgColor),
          ],
        ),
        Row(
          children: [
            openScientific
                ? button(
                    text: "π",
                    textColor: widget.dullColor,
                    bgColor: widget.bgColor)
                : Container(),
            button(
                text: "1",
                textColor: widget.textColor,
                bgColor: widget.bgColor),
            button(
                text: "2",
                textColor: widget.textColor,
                bgColor: widget.bgColor),
            button(
                text: "3",
                textColor: widget.textColor,
                bgColor: widget.bgColor),
            button(
                text: "+",
                textColor: widget.operatorColor,
                bgColor: widget.bgColor),
          ],
        ),
        Row(
          children: [
            button(
                text: "modechange",
                textColor: widget.operatorColor,
                bgColor: widget.bgColor),
            openScientific
                ? button(
                    text: "e",
                    textColor: widget.textColor,
                    bgColor: widget.bgColor)
                : Container(),
            button(
                text: "0",
                textColor: widget.textColor,
                bgColor: widget.bgColor),
            button(
                text: ".",
                textColor: widget.textColor,
                bgColor: widget.bgColor),
            button(
                text: "=",
                textColor: widget.bgColor,
                bgColor: widget.operatorColor),
          ],
        ),
      ],
    );
  }

  Widget button({text, textColor = Colors.white, bgColor}) {
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
            elevation: 0,
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
