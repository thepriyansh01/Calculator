import 'package:flutter/material.dart';
import 'package:mycalc/colors.dart';
import 'package:mycalc/pages/bmi_calc.dart';
import 'package:mycalc/pages/calc_page.dart';

class TabBarWidget extends StatefulWidget {
  const TabBarWidget({super.key});

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget> {
  Color textColor = getTextColor();
  Color operatorColor = getOperatorColor();
  Color dullColor = getDullColor();
  Color bgColor = getBgColor();

  void toggleTheme() {
    setState(() {
      isDarkTheme = !isDarkTheme;

      textColor = getTextColor();
      operatorColor = getOperatorColor();
      dullColor = getDullColor();
      bgColor = getBgColor();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(
                isDarkTheme ? Icons.light_mode : Icons.dark_mode,
                color: bgColor,
              ),
              onPressed: toggleTheme,
            ),
          ],
          backgroundColor: operatorColor,
          title: Text(
            "CaLculator",
            style: TextStyle(
                color: bgColor, fontSize: 25, fontWeight: FontWeight.w500),
          ),
          bottom: TabBar(tabs: [
            Tab(
              icon: Icon(
                Icons.calculate_rounded,
                color: bgColor,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.health_and_safety_rounded,
                color: bgColor,
              ),
            ),
          ]),
        ),
        body: TabBarView(children: [
          // First Tab Content
          Center(
            child: CalculatorApp(
              textColor: textColor,
              operatorColor: operatorColor,
              dullColor: dullColor,
              bgColor: bgColor,
            ),
          ),

          // Second Tab Content
          Center(
            child: BMI(
              textColor: textColor,
              operatorColor: operatorColor,
              dullColor: dullColor,
              bgColor: bgColor,
            ),
          ),
        ]),
      ),
    );
  }
}
