import 'package:flutter/material.dart';
import 'package:msd_project_food_diary/Data/DatabaseHelper.dart';
import 'package:msd_project_food_diary/Data/SharedPreferences/SharedPreferencesHelper.dart';
import 'package:msd_project_food_diary/Model/Bmi.dart';
import 'package:msd_project_food_diary/ResetPassword/MainFolder/BMIResult.dart';

class BMIInfoScreen extends StatefulWidget {
  final String gender;

  BMIInfoScreen({required this.gender});

  @override
  _BMIInfoScreenState createState() => _BMIInfoScreenState();
}

class _BMIInfoScreenState extends State<BMIInfoScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final double initialHeight = 100.0;
  final Databasehelper handler = Databasehelper();
  String? username = "";
  List<BMI> bmiList = [];
  double currentHeight = 100.0;
  bool isSliderValid = false;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    handler.InitiDb();
    loadUsername();
    loadData();
        controller=AnimationController(vsync: this, duration: Duration(milliseconds: 500));

  }

  Future<void> loadUsername() async {
    username = await SharedPreferenceHelper().getUsername();
    setState(() {});
  }

  Future<void> loadData() async {
    bmiList = await handler.RetrieveBMI(username!);
    setState(() {});
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
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, size: 25, color: Color(0xFF9D8160)),
          ),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildHeightSelector(),
                if (!isSliderValid)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Please select a valid height.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                buildWeightAndAgeFields(),
                SizedBox(height: 50),
                buildButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

 Widget buildHeightSelector() {
  return Padding(
    padding: EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How tall are you?',
          style: TextStyle(
              color: Color(0xFF9D8160),
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Text("(in cm)", style: TextStyle(color: Color(0xFF9D8160))),
        SizedBox(height: 30),
        Center(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 3, color: Color(0xFFF8E8D6)),
                  color: Color(0xFFEADDCD),
                ),
                width: 340,
                height: 130,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 10,
                        left: 0,
                        right: 0,
                        child: buildHeightLabels(),
                      ),
                      Positioned(
                        top: 50,
                        left: 0,
                        right: 0,
                        child: Slider(
                          thumbColor: Colors.black,
                          inactiveColor: Color(0xFF9D8160),
                          activeColor: Color(0xFF9D8160),
                          min: 100.0,
                          max: 200.0,
                          value: currentHeight,
                          divisions: 100,
                          onChanged: onSliderChanged,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20), // Add some space between the slider and the text
              Text(
                'Selected Height: ${currentHeight.toStringAsFixed(0)} cm',
                style: TextStyle(
                  color: Color(0xFF9D8160),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


  Widget buildHeightLabels() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        11,
        (index) {
          final value = 100 + (index * 10);
          return AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              final highlighted = value.round() == currentHeight.round();
              final color = highlighted ? Color(0xFF9D8160) : Colors.black;
              final size = highlighted ? 20.0 : 12.0;
              return Row(
                children: [
                  Text(
                    '$value',
                    style: TextStyle(
                      fontSize: size,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  SizedBox(width: 2),
                  Text('|', style: TextStyle(fontSize: 12)),
                ],
              );
            },
          );
        },
      ),
    );
  }
  void onSliderChanged(double value) {
    setState(() {
      currentHeight = value;
      isSliderValid = true;
    });
    controller.forward(from: 0);
  }
  Widget buildWeightAndAgeFields() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          buildFormField("Weight(kg)", TextInputType.number, weightController,
              (value) {
            if (value == null || value.isEmpty) {
              return "Weight is required";
            }
            return null;
          }),
          buildFormField("Age", TextInputType.number, ageController, (value) {
            if (value == null || value.isEmpty) {
              return "Age is required";
            }
            return null;
          }),
        ],
      ),
    );
  }

  Widget buildFormField(
      String labelText,
      TextInputType keyboardType,
      TextEditingController controller,
      String? Function(String?)? validator) {
    return Column(
      children: [
        Text(
          labelText,
          style: TextStyle(
              color: Color(0xFF9D8160),
              fontSize: 15,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Container(
          width: 150,
          height: 50,
          decoration: BoxDecoration(
              border:
                  Border.all(color: Color(0xFFF8E8D6), width: 2)),
          child: TextFormField(
            keyboardType: keyboardType,
            controller: controller,
            validator: validator,
            decoration: InputDecoration(
              alignLabelWithHint: true,
              labelText: labelText,
              border: OutlineInputBorder(),
            ),
          ),
        )
      ],
    );
  }

  Widget buildButtons() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          buildButton("Clear", onClearPressed),
          buildButton("Calculate", isSliderValid ? onCalculatePressed : null),
        ],
      ),
    );
  }

  Widget buildButton(String label, void Function()? onPressed) {
    return Container(
      width: 150,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(
            Icons.refresh,
            size: 20,
            color: Colors.white,
          ),
          Text(label)
        ]),
        style: ElevatedButton.styleFrom(
          elevation: 10.0,
          primary: Color(0xFFF47C54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
      ),
    );
  }

  void onClearPressed() {
    ageController.clear();
    currentHeight = initialHeight;
    weightController.clear();
    setState(() {});
  }

  void onCalculatePressed() async {
    if (formKey.currentState!.validate()) {
      double weight = double.parse(weightController.text.toString());
      double height = double.parse(currentHeight.toString());
      double bmi = calculateBMI(height, weight);

      if (bmiList.isNotEmpty) {
        await handler.UpdateBMI(BMI(username: username!, bmi: bmi));
      } else {
        await handler.InsertBMI(BMI(username: username!, bmi: bmi));
      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  BMIResultScreen(BMI: bmi, gender: widget.gender)));
    }
  }

  double calculateBMI(double heightInCm, double weightInKg) {
    double heightInMeter = heightInCm / 100;
    double bmi = weightInKg / (heightInMeter * heightInMeter);
    return double.parse(bmi.toStringAsFixed(1));
  }
}
