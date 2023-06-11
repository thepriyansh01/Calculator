import 'package:flutter/material.dart';
import 'package:mycalc/colors.dart';
import 'package:mycalc/pages/bmi_calc.dart';
import 'package:mycalc/pages/calc_page.dart';

class TabBarWidget extends StatelessWidget {
  const TabBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: operatorColor,
          title: const Text("Calculator"),
          bottom: const TabBar(tabs: [
            Tab(
              icon: Icon(
                Icons.calculate_rounded,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.health_and_safety_rounded,
              ),
            ),
          ]),
        ),
        body: TabBarView(children: [
          // First Tab Content
          Container(
            color: Colors.red,
            child: const Center(
              child: CalculatorApp(),
            ),
          ),

          // Second Tab Content
          Container(
            color: Colors.green,
            child: const Center(
              child: BMI(),
            ),
          ),
        ]),
      ),
    );
  }
}
