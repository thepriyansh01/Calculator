import 'package:flutter/material.dart';

class BMI extends StatefulWidget {
  final Color dullColor;
  final Color operatorColor;
  final Color textColor;
  final Color bgColor;

  const BMI({
    Key? key,
    required this.textColor,
    required this.operatorColor,
    required this.dullColor,
    required this.bgColor,
  }) : super(key: key);

  @override
  State<BMI> createState() => _BMIState();
}

class _BMIState extends State<BMI> {
  double weight = 60;
  double height = 178;
  double age = 21;
  double bmi = 19;
  String status = "Normal";

  void handleUpdate(String name, String action) {
    if (action == "increase") {
      if (name == "age") {
        if (age <= 100) {
          age += 1;
        }
      } else if (name == "weight") {
        weight += 1;
      } else if (name == "height") {
        height += 1;
      }
    } else {
      if (name == "age") {
        if (age >= 1) {
          age -= 1;
        }
      } else if (name == "weight") {
        if (weight >= 1) {
          weight -= 1;
        }
      } else if (name == "height") {
        if (height >= 1) {
          height -= 1;
        }
      }
    }
    setState(() {});
  }

  void calculateBMI() {
    double heightInMeters = height / 100;
    bmi = weight / (heightInMeters * heightInMeters);

    if (age < 18.0) {
      bmi *= 1.2;
    }

    // Round the BMI value to two decimal places
    double roundedBMI = double.parse(bmi.toStringAsFixed(2));

    bmi = roundedBMI;
    if (bmi < 18.5) {
      status = "Underweight";
    } else if (bmi >= 18.5 && bmi < 25) {
      status = "Normal weight";
    } else if (bmi >= 25 && bmi < 30) {
      status = "Overweight";
    } else {
      status = "Obese";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
          backgroundColor: widget.bgColor,
          body: Container(
              decoration: const BoxDecoration(
                  // image: DecorationImage(image: AssetImage(assetName)),
                  ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 40, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(children: <Widget>[
                          Text(
                            "BMI",
                            style: TextStyle(
                              color: widget.textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          dots(),
                          dots(),
                          dots(),
                          dots(),
                        ]),
                        Text(
                          "CALCULATOR",
                          style: TextStyle(
                            fontSize: 27,
                            color: widget.textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        bmi.toString(),
                        style: TextStyle(
                          fontSize: 120,
                          color: widget.operatorColor,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        status,
                        style: TextStyle(
                          color: widget.dullColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Row(
                        children: <Widget>[
                          buttonToUpdate("age", "decrease"),
                          Expanded(
                              flex: 0,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    age.toString(),
                                    style: TextStyle(
                                      color: widget.textColor,
                                      fontSize: 35,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "years",
                                    style: TextStyle(
                                      color: widget.dullColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )),
                          buttonToUpdate("age", "increase"),
                        ],
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Row(
                        children: <Widget>[
                          buttonToUpdate("height", "decrease"),
                          Expanded(
                              flex: 0,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    height.toString(),
                                    style: TextStyle(
                                      color: widget.textColor,
                                      fontSize: 35,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "cm",
                                    style: TextStyle(
                                      color: widget.dullColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )),
                          buttonToUpdate("height", "increase"),
                        ],
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Row(
                        children: <Widget>[
                          buttonToUpdate("weight", "decrease"),
                          Expanded(
                              flex: 0,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    weight.toString(),
                                    style: TextStyle(
                                      color: widget.textColor,
                                      fontSize: 35,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "kg",
                                    style: TextStyle(
                                      color: widget.dullColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )),
                          buttonToUpdate("weight", "increase"),
                        ],
                      )
                    ],
                  )),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => calculateBMI(),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(10),
                          backgroundColor: widget.operatorColor,
                        ),
                        child: Text(
                          "Calculate",
                          style: TextStyle(
                            color: widget.bgColor,
                            fontSize: 26,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ))),
    );
  }

  Widget buttonToUpdate(String name, String action) {
    return Expanded(
      child: TextButton(
        onPressed: () => handleUpdate(name, action),
        child: Icon(
          action == "increase" ? Icons.add : Icons.remove,
          size: 50,
          color: widget.operatorColor,
        ),
      ),
    );
  }

  Widget dots() {
    return Container(
      margin: const EdgeInsets.only(left: 2),
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.textColor,
      ),
    );
  }
}
