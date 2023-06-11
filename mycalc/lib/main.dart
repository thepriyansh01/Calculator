import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:mycalc/colors.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scientific Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      home: const CalculatorApp(),
    );
  }
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  double value1 = 0.0;
  double value2 = 0.0;
  var input = "";
  var output = "";
  var operation = "";
  var hideInput = false;
  double outputSize = 34;
  double outputOpacity = 0.7;

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
    } else {
      if (value == "back" || value == "modechange") {
        value = "";
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
          Row(
            children: [
              button(text: "AC", textColor: operatorColor),
              button(text: "back", textColor: operatorColor),
              button(text: "%", textColor: operatorColor),
              button(text: "÷", textColor: operatorColor),
            ],
          ),
          Row(
            children: [
              button(text: "7"),
              button(text: "8"),
              button(text: "9"),
              button(text: "x", textColor: operatorColor),
            ],
          ),
          Row(
            children: [
              button(text: "4"),
              button(text: "5"),
              button(text: "6"),
              button(text: "-", textColor: operatorColor),
            ],
          ),
          Row(
            children: [
              button(text: "1"),
              button(text: "2"),
              button(text: "3"),
              button(text: "+", textColor: operatorColor),
            ],
          ),
          Row(
            children: [
              button(text: "modechange", textColor: operatorColor),
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
      case '%':
        iconData = Icons.percent;
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
        margin: const EdgeInsets.all(8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            padding: const EdgeInsets.all(22),
            backgroundColor: bgColor,
          ),
          onPressed: () => onClick(text),
          child: iconData != null
              ? Icon(
                  iconData,
                  size: 30,
                  color: textColor,
                )
              : Text(
                  text,
                  style: TextStyle(
                    fontSize: 30,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
