import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:msd_project_food_diary/Data/DatabaseHelper.dart';
import 'package:msd_project_food_diary/Data/SharedPreferences/SharedPreferencesHelper.dart';
import 'package:msd_project_food_diary/Model/Calories.dart';
import 'package:msd_project_food_diary/ResetPassword/MainFolder/CaloriesResult.dart';

class CaloriesCalculate extends StatefulWidget {
  const CaloriesCalculate({Key? key});

  @override
  State<CaloriesCalculate> createState() => _CaloriesCalculateState();
}

class _CaloriesCalculateState extends State<CaloriesCalculate> {
  late final TextEditingController age = TextEditingController();
  late final TextEditingController weight = TextEditingController();
  late final TextEditingController height = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late Databasehelper handler;
  String? Username = "";
  String? selectedOption;
  String imagePath = "";
  String? genderOption;
  String? selectedActivityLevel;

  @override
  void initState() {
    super.initState();
    handler = Databasehelper();
    handler.InitiDb();
    LoadUsername();
  }

  Future<void> LoadUsername() async {
    Username = await SharedPreferenceHelper().getUsername();
    setState(() {});
  }

  List<String> Goals = ["Maintain weight", "Lose weight"];
  List<String> Genders = ["Male", "Female"];
  List<String> activityLevel = [
    "Seated most of the day",
    "Sedentary",
    "Moderately active",
    "Active",
    "Very active"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: null,
      body: Form(
        key: formKey,
        child: Container(
          height: double.infinity,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -250,
                left: -50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(500),
                  child: Container(
                    width: 500,
                    height: 500,
                    color: Color(0xFFE5F0C5),
                  ),
                ),
              ),
              Positioned(
                top: 50,
                left: 20,
                child: Row(
                  children: [
                    Text(
                      "Calories \n Calculator",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF042960),
                        shadows: [
                          Shadow(color: Colors.black, offset: Offset(1, 1))
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Image.asset(
                      "Image/diet.png",
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    )
                  ],
                ),
              ),
              Positioned(
                top: 250,
                child: Container(
                  width: 400,
                  height: 600,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        buildDropdown("Goal", Goals, (String? value) {
                          setState(() {
                            selectedOption = value!;
                          });
                        }),
                        buildDropdown("Gender", Genders, (String? value) {
                          setState(() {
                            genderOption = value!;
                          });
                        }),
                        buildTextFormField("Age", age),
                        buildRowTextFormField("Height", "Weight", height, weight),
                        buildDropdown(
                            "Activity level", activityLevel, (String? value) {
                          setState(() {
                            selectedActivityLevel = value!;
                          });
                        }),
                        buildButtonRow(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        selectedItemColor: Colors.black,
        showSelectedLabels: true,
        currentIndex: 2,
        onTap: (value) {
          if (value == 0) {
            Navigator.pushNamed(context, "/");
          }else if (value == 1) {
            Navigator.pushNamed(context, "/BMICalculator");
          } else if (value == 3) {
            Navigator.pushNamed(context, "/FoodDairy");
          }
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 20, color: Colors.black),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calculate, size: 20, color: Colors.black),
              label: "BMI"),
          BottomNavigationBarItem(
              icon: Icon(Icons.fastfood, size: 20, color: Colors.black),
              label: "Calories"),
          BottomNavigationBarItem(
              icon: Icon(Icons.emoji_food_beverage,
                  size: 20, color: Colors.black),
              label: "Dairy"),
        ],
      ),
    );
  }

  Widget buildDropdown(String label, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.blue.shade900,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 10),
          DropdownButtonFormField<String>(
            
            onSaved: onChanged,
            validator: (value) {
              if (value == "" || value == null) {
                return "$label is required";
              }
              return null;
            },
            isExpanded: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Select $label",
            ),
            items: items.map((String element) {
              return DropdownMenuItem<String>(
                value: element.toString(),
                child: Text(element),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget buildTextFormField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.blue.shade900,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            validator: (value) {
              if (value!.isEmpty || value == "") {
                return "$label is required";
              }
              return null;
            },
            keyboardType: TextInputType.number,
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: label,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRowTextFormField(String label1, String label2, TextEditingController controller1, TextEditingController controller2) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label1,
                style: TextStyle(
                  color: Colors.blue.shade900,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                label2,
                style: TextStyle(
                  color: Colors.blue.shade900,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  validator: (value) {
                    if (value == "" || value!.isEmpty) {
                      return "$label1 is required";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  controller: controller1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: label1,
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: TextFormField(
                  validator: (value) {
                    if (value == "" || value!.isEmpty) {
                      return "$label2 is required";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: controller2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: label2,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildButtonRow() {
    return Padding(
      padding: EdgeInsets.only(bottom: 200, left: 20),
      child: Row(
        children: [
          buildElevatedButton("Clear", Colors.black, () async{
           await FirebaseAnalytics.instance.logEvent(
            name: "Clear Button from Calories",
            parameters: {
              "Action Name":"Clear",
              "Action Trigger":"Done"
            }
          );
  age.clear();
  weight.clear();
  height.clear();
  selectedOption = null; // Clear the selectedOption
  genderOption = null; // Clear the genderOption
  selectedActivityLevel = null; // Clear the selectedActivityLevel 
  setState(() {
});


          }),
          SizedBox(width: 20),
          buildElevatedButton("Calculate", Colors.black, () async {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              double bmr = selectedOption == 'Maintain weight'
                  ? calculateMaintainCalories()
                  : calculateLoseWeightCalories();

              await handler.InsertRecordsBMR(
                CaloriesData(
                  username: Username,
                  bmr: bmr,
                ),
              );

              String recommendations = getRecommendations(bmr);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Calories(
                    bmr: bmr,
                    activity: selectedActivityLevel!,
                    recommand: recommendations,
                    imagePath: imagePath,
                  ),
                ),
              );
            }
          }),
        ],
      ),
    );
  }

  Widget buildElevatedButton(String text, Color textColor, void Function()? onPressed) {
    return Card(
      child: Container(
        width: 150,
        height: 30,
        child: ElevatedButton(
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFE5F0C5),
          ),
        ),
      ),
    );
  }

  double calculateMaintainCalories() {
    const double caloriesPerKg = 24;
    const double maleModifier = 5;
    const double femaleModifier = -161;

    const Map<String, double> activityLevelMultipliers = {
      "Seated most of the day": 1.2,
      "Sedentary": 1.375,
      "Moderately active": 1.55,
      "Active": 1.725,
      "Very active": 1.9,
    };

    double Height = double.parse(height.text);
    double Weight = double.parse(weight.text);
    int Age = int.parse(age.text);

    double bmr;
    if (genderOption == 'Male') {
      bmr = (caloriesPerKg * Weight) +
          (maleModifier * Height) -
          (5 * Age) +
          5;
    } else {
      bmr = (caloriesPerKg * Weight) +
          (femaleModifier * Height) -
          (5 * Age) -
          161;
    }

    double maintainCalories = bmr * activityLevelMultipliers[selectedActivityLevel]!;

    return double.parse((maintainCalories >= 0 ? maintainCalories : 0).toStringAsFixed(2));
  }

  double calculateLoseWeightCalories() {
    const double deficitPercentage = 0.20;

    double maintenanceCalories = calculateMaintainCalories();

    double loseWeightCalories = maintenanceCalories * (1 - deficitPercentage);

    return double.parse((loseWeightCalories >= 0 ? loseWeightCalories : 0).toStringAsFixed(2));
  }

  String getRecommendations(double bmr) {
    String recommendations = '';

    double calorieDifference = bmr - 2000;

    if (calorieDifference > 0) {
      recommendations += 'You have a calorie surplus. Consider reducing your calorie intake.\n';
    } else if (calorieDifference < 0) {
      recommendations += 'You have a calorie deficit. Consider increasing your calorie intake or consulting a nutritionist.\n';
    } else {
      recommendations += 'Your calorie intake matches your BMR. Maintain your current eating habits.\n';
    }

    switch (selectedActivityLevel) {
      case "Seated most of the day":
        recommendations += 'Since you are seated most of the day, try to incorporate more physical activity into your routine. Consider taking short walks or stretching breaks throughout the day.\n';
        imagePath = "Image/Walking.png";
        break;
      case "Sedentary":
        recommendations += 'Being sedentary increases health risks. Aim for at least 30 minutes of moderate exercise most days of the week. Activities like brisk walking, cycling, or swimming can be beneficial.\n';
        imagePath = "Image/Cycling.png";
        break;
      case "Moderately active":
        recommendations += 'You are moderately active, which is great! Keep up the good work by staying consistent with your exercise routine and maintaining a balanced diet.\n';
        imagePath = "Image/BalanceDiet.png";
        break;
      case "Active":
        recommendations += 'Being active is excellent for your health! Continue to engage in regular physical activity and maintain a balanced diet to support your active lifestyle.\n';
        imagePath = "Image/Running.png";
        break;
      case "Very active":
        recommendations += 'You have a very active lifestyle! Make sure to fuel your body with nutritious foods to support your energy needs and recovery from exercise.\n';
        imagePath = "Image/Workouts.png";
        break;
      default:
        recommendations += 'No activity level selected.\n';
        imagePath = "Image/diet.png";
    }

    return recommendations;
  }
}
