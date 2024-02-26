import 'package:flutter/material.dart';
import 'package:msd_project_food_diary/ResetPassword/MainFolder/BMInfor.dart';



class BMICalculatorScreen extends StatefulWidget {
  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  double height = 0.0;
  double weight = 0.0;
  String? selectedGender;
  List<String> gender = ["Female", "Male"];
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: null,
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'BMI Calculator',
                    style: TextStyle(
                        color: Color(0xFF9D8160),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'What is your Gender?',
                    style: TextStyle(
                        color: Color(0xFF9D8160),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      buildGenderImage("Image/female.png"),
                      buildGenderImage("Image/male.png"),
                    ],
                  ),
                  SizedBox(height: 5),
                  buildGenderDropdown(),
                  SizedBox(height: 20),
                  buildNextButton(),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: buildBottomNavigationBar(),
      ),
    );
  }

  Widget buildGenderImage(String imagePath) {
    return Expanded(
      child: Container(
        width: 200,
        height: 300,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.asset(imagePath),
        ),
      ),
    );
  }

  Widget buildGenderDropdown() {
    return Container(
      width: 400,
      child: DropdownButtonFormField<String>(
        onSaved: (newValue) {
          setState(() {
            selectedGender = newValue!;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Gender is required";
          }
          return null;
        },
        isExpanded: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Select Gender",
        ),
        items: gender.map((String element) {
          return DropdownMenuItem<String>(
            value: element,
            child: Text(element),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            selectedGender = value!;
          });
        },
      ),
    );
  }

  Widget buildNextButton() {
    return Container(
      width: 350,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return BMIInfoScreen(gender: selectedGender!);
              }),
            );
          }
        },
        child: Text("Next"),
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
  Widget buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      unselectedItemColor: Colors.black,
      showUnselectedLabels: true,
      selectedItemColor: Colors.black,
      showSelectedLabels: true,
      currentIndex: 1,
      onTap: (value) {
        switch (value) {
          case 0:
            Navigator.pushNamed(context, "/");
            break;
          case 2:
            Navigator.pushNamed(context, "/CaloriesCalculator");
            break;
          case 3:
            Navigator.pushNamed(context, "/FoodDairy");
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 20, color: Colors.black),
          label: "Home",
        ),
      
        BottomNavigationBarItem(
          icon: Icon(Icons.calculate, size: 20, color: Colors.black),
          label: "BMI",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fastfood, size: 20, color: Colors.black),
          label: "Calories",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_food_beverage, size: 20, color: Colors.black),
          label: "Dairy",
        ),
      ],
    );
  }
}
