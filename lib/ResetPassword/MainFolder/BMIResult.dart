import 'package:flutter/material.dart';
import 'package:msd_project_food_diary/Data/DatabaseHelper.dart';
import 'package:msd_project_food_diary/Model/Bmi.dart';
import 'package:msd_project_food_diary/ResetPassword/MainFolder/BMICalculator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class BMIResultScreen extends StatefulWidget {
  final double? BMI;
  final String? gender;
 const BMIResultScreen({Key? key, required this.BMI, required this.gender}) : super(key: key);
  @override
  _BMIResultScreenState createState() => _BMIResultScreenState();
}

class _BMIResultScreenState extends State<BMIResultScreen> {
  late Databasehelper handler;
  List<String> tips = [];
  bool? ismale;
  @override
  void initState() {
    super.initState();
    handler = Databasehelper();
    handler.InitiDb();
    getBMITipsDescription(widget.BMI!);
    ismale = (widget.gender == "Male");
  }
  String _getBMIStatus(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi < 24.9) {
      return 'Normal';
    } else if (bmi < 29.9) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return BMICalculatorScreen();
              }));
            },
            child: const Icon(Icons.arrow_back, size: 25, color: Color(0xFF9D8160)),
          ),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Center(
                child: Text(
                  "Results",
                  style: TextStyle(color: Color(0xFF9D8160), fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                children: [
                 const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.BMI.toString(),
                    style: const TextStyle(color: Color(0xFF9D8160), fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                 const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 300,
                    height: 300,
                    child: SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                          minimum: 0,
                          maximum: 40,
                          showLabels: false,
                          showTicks: false,
                          axisLineStyle:const AxisLineStyle(
                            thickness: 20,
                            cornerStyle: CornerStyle.bothFlat,
                            color: Colors.transparent,
                          ),
                          ranges: <GaugeRange>[
                            GaugeRange(
                              startValue: 0,
                              endValue: 18.5,
                              startWidth: 20,
                              endWidth: 20,
                              color: Colors.blue,
                              gradient: const SweepGradient(
                                colors: <Color>[Colors.blue, Colors.green],
                                stops: <double>[0.0, 1.0],
                              ),
                            ),
                            GaugeRange(
                              startValue: 18.5,
                              endValue: 24.9,
                              startWidth: 20,
                              endWidth: 20,
                              color: Colors.green,
                              gradient: const SweepGradient(
                                colors: <Color>[Colors.green, Colors.orange],
                                stops: <double>[0.0, 1.0],
                              ),
                            ),
                            GaugeRange(
                              startValue: 25.0,
                              endValue: 29.9,
                              startWidth: 20,
                              endWidth: 20,
                              color: Colors.orange,
                              gradient: const SweepGradient(
                                colors: <Color>[Colors.orange, Colors.red],
                                stops: <double>[0.0, 1.0],
                              ),
                            ),
                            GaugeRange(
                              startValue: 30.0,
                              endValue: 40,
                              startWidth: 20,
                              endWidth: 20,
                              color: Colors.red,
                              gradient: const SweepGradient(
                                colors: <Color>[Colors.red, Colors.red],
                                stops: <double>[0.0, 1.0],
                              ),
                            ),
                          ],
                          pointers: <GaugePointer>[
                            NeedlePointer(
                              value: widget.BMI!,
                              enableAnimation: true,
                              animationType: AnimationType.easeOutBack,
                              animationDuration: 1200,
                              needleLength: 0.5,
                            ),
                          ],
                          startAngle: 180,
                          endAngle: 0,
                          annotations: [
                            GaugeAnnotation(
                              widget: Column(
                                children: [
                                  const Text(
                                    "Your BMI:",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: "SegoeUIBold",
                                    ),
                                  ),
                                  Text(
                                    '${widget.BMI!.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "SegoeUIBold",
                                    ),
                                  ),
                                  Text(
                                    _getBMIStatus(widget.BMI!),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "SegoeUIBold",
                                    ),
                                  ),
                                  SizedBox(height: 13),
                                ],
                              ),
                              positionFactor: 1.4,
                              angle: 90,
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: RowTips(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Card(
                  color:const Color(0xFFEADDCD),
                  elevation: 10.0,
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: tips.map((tip) => ListTile(
                        leading:const Icon(Icons.circle, size: 10),
                        title: Text(tip, style: const TextStyle(fontSize: 10)),
                      )).toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ImageDisplayResult(),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Row RowTips() {
    return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Tips",
                    style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: 40,
                    height: 40,
                    child: Icon(Icons.lightbulb_circle, size: 30, color: Colors.black),
                  )
                ],
              );
  }

  Row ImageDisplayResult() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 200,
          height: 200,
          child: ismale! ? Image.asset("Image/BMIMale.png", fit: BoxFit.contain) : Image.asset("Image/BMIFemale.png", fit: BoxFit.contain),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Container(
            width: 150,
            height: 150,
            child: Text(
              getBMIResultDescription(widget.BMI!),
              style: TextStyle(color: Color(0xFF9D8160), fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  String getBMIResultDescription(double bmi) {
    if (bmi < 18.5) {
      return "Underweight: Individuals with a BMI below 18.5 are considered underweight.";
    } else if (bmi >= 18.5 && bmi < 25.0) {
      return "Normal Weight:\n\n A BMI falling within the range of 18.5 to 24.9 is considered normal or healthy.";
    } else if (bmi >= 25.0 && bmi < 30.0) {
      return "Overweight:\n\n Individuals with a BMI between 25.0 and 29.9 are considered overweight.";
    } else if (bmi >= 30.0 && bmi < 35.0) {
      return "Obese (Class 1):\n\n Obesity class 1 is defined by a BMI between 30.0 and 34.9.";
    } else if (bmi >= 35.0 && bmi < 40.0) {
      return "Obese (Class 2):\n\n Obesity class 2 is characterized by a BMI between 35.0 and 39.9.";
    } else {
      return "Obese (Class 3 or Morbidly Obese):\n\n Obesity class 3, also known as morbid obesity, is defined by a BMI of 40.0 and above.";
    }
  }

  void getBMITipsDescription(double bmi) {
    if (bmi < 18.5) {
      tips.addAll([
        "Aim to increase calorie intake through nutritious foods.",
        "Incorporate strength training exercises to build muscle mass.",
        "Consult with a healthcare professional to address any underlying health concerns.",
      ]);
    } else if (bmi >= 18.5 && bmi < 25) {
      tips.addAll([
        "Maintain a balanced diet with plenty of fruits, vegetables, and lean proteins.",
        "Stay physically active with regular exercise.",
        "Monitor your weight and make adjustments to your diet and exercise routine as needed.",
      ]);
    } else if (bmi >= 25 && bmi < 30) {
      tips.addAll([
        "Focus on portion control and avoid overeating.",
        "Incorporate more high-fiber foods into your diet to promote feelings of fullness.",
        "Engage in regular cardiovascular exercise to help burn excess fat.",
      ]);
    } else if (bmi >= 30) {
      tips.addAll([
        "Seek support from a healthcare professional or weight loss program.",
        "Set realistic weight loss goals and track your progress.",
        "Make lifestyle changes to improve diet and increase physical activity levels.",
      ]);
    }
    setState(() {});
  }
}
