import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:ui';
import 'package:intl/intl.dart'; // Import intl package for date formatting
import 'package:camera/camera.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:msd_project_food_diary/Carousel/Feature.dart';
import 'package:msd_project_food_diary/Data/DatabaseHelper.dart';
import 'package:msd_project_food_diary/Data/SharedPreferences/SharedPreferencesHelper.dart';
import 'package:msd_project_food_diary/Model/Bmi.dart';
import 'package:msd_project_food_diary/Model/Calories.dart';
import 'package:msd_project_food_diary/Model/UserGathering.dart';
import 'package:msd_project_food_diary/Model/profileimage.dart';
import 'package:msd_project_food_diary/ResetPassword/MainFolder/BMICalculator.dart';
import 'package:msd_project_food_diary/ResetPassword/MainFolder/CaloriesCalculator.dart';
import 'package:msd_project_food_diary/ResetPassword/MainFolder/DisplayPicture.dart';
import 'package:msd_project_food_diary/ResetPassword/MainFolder/UserProfile.dart';
import 'package:msd_project_food_diary/ResetPassword/MainFolder/profile.dart';
import 'package:msd_project_food_diary/main.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../firebase_options.dart';


class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [
 FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)
  ],
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => HomePage(),
        "/BMICalculator": (context) => BMICalculatorScreen(),
        "/CaloriesCalculator": (context) => CaloriesCalculate(),
        "/FoodDairy": (context) => DisplayPictureScreen(
          imagePath: '',
        ),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? username = "";
  bool? isMale = true;
  double BMIfilter=0.0;
    double CaloriesFilter=0.0;
  String? userssname = "";
  bool loading = true;
  late Databasehelper handler;
    final double maxCaloriesPerDay = 3000; // Example: Maximum calories per day
double percentage=0.0;
  bool _isAtTop = true;
  bool onlastpage = false;
  int pagetrack = 0;
  late Timer timer;
  late PageController controller;
  List<UserProfile> userprofile = [];
  List<BMI>BmiSingleRecord=[];
  List<BMI> bmiList = [];
  List<CaloriesData> CaloriesList = [];
  List<CaloriesData> CaloriesSingleRecord = [];
  List<BMIChartData> filteredBMIChartData = [];
  List<ProfileImageModel>profiles=[];
  bool _isLoading = true; // Added loading indicator state
  final double maxCalories = 2500; // Maximum recommended calories per day

  double _calculateProgress(double calories, double maxCalories) {
    // Calculate the progress value based on the calorie intake
    return calories / maxCalories * 100; // Multiply by 100 to scale to the range 0-100
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
  void initState() {  
       controller = PageController();

    super.initState();
    handler = Databasehelper();
    loaddata();
    loadUsername().then((value) async {
await RetrieveUserprofile();
      await loadLastRecordsCalories();
      await loadLastRecordsBMI();
      await LoadRecordsBMI();
      await LoadRecordBMR();
  await loadUserProfile();
      setState(() {
        _isLoading = false; // Update loading state when data fetching is complete
      });
      
    });
    
  }
    Color _getTextColor(double calories) {
    if (calories <= 1500) {
      return Colors.green;
    } else if (calories <= 2500) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
  Future<void>loadUserProfile()async{
  profiles = await handler.RetrieveProfileImage(username);

setState(() {
  
});

}

Future<void>RetrieveUserprofile()async{
  userprofile=await handler.RetriveProfile(userssname!);
  setState(() {
    
  });
}
 void preventDuplicate() async {
  Set<double> uniqueBMIs = bmiList.map((bmi) => bmi.bmi).toSet();
  
  // Convert the set of unique BMI values back to a list of BMI objects
  List<BMI> uniqueBMIList = uniqueBMIs.map((bmiValue) => BMI(bmi: bmiValue,username: userssname!)).toList();
  
  // Assign the unique list back to bmiList
  bmiList = uniqueBMIList;

  setState(() {});
}

void generateFilteredChartData(double filterValue) {
  // Clear the previous filtered data

  filteredBMIChartData.clear();

  // Iterate over the original BMI data and add data points to filteredBMIChartData
  for (int i = 0; i < bmiList.length; i++) {
    double bmiValue = bmiList[i].bmi; // Access the BMI value from the list
    // Check if the BMI value matches the selected filter value
    if (bmiValue >= filterValue) {
      filteredBMIChartData.add(BMIChartData(bmiValue));
    }
  }

  // Update the UI
  setState(() {});
}

void generateFilteredChartDataBMR(double filterValue) {
  // Clear the previous filtered data
  filteredBMIChartData.clear();

  // Iterate over the original BMI data and add data points to filteredBMIChartData
  for (int i = 0; i <CaloriesList.length; i++) {
    double ?bmiValue = CaloriesList[i].bmr; // Access the BMI value from the list
    // Check if the BMI value matches the selected filter value
    if (bmiValue !>= filterValue) {
      filteredBMIChartData.add(BMIChartData(bmiValue));
    }
  }

  // Update the UI
  setState(() {});
}


   Future<void>LoadRecordBMR()async{
    CaloriesList= await handler.RetrieveBMRRecords(userssname!);
    setState(() {
      
    });

  }

  Future<void>LoadRecordsBMI()async{
    bmiList= await handler.RetrieveBMI(userssname!);
    setState(() {
      
    });
preventDuplicate();
  }
  String getLegendText(String name) {
  switch (name) {
    case 'Underweight':
      return 'Underweight (BMI < 18.5)';
    case 'Normal weight':
      return 'Normal weight (18.5 ≤ BMI < 24.9)';
    case 'Overweight':
      return 'Overweight (24.9 ≤ BMI < 29.9)';
    case 'Obese':
      return 'Obese (BMI ≥ 30)';
    default:
      return '';
  }
}


  Future<void> loadLastRecordsCalories() async {
final lastBMR = await handler.retrieveLastBMR(userssname!);
if (lastBMR != null) {
  CaloriesSingleRecord = [lastBMR];
} else {
  CaloriesSingleRecord = [];
}

  }
  
  Future<void> loadLastRecordsBMI() async {
final lastBMR = await handler.RetrieveLastBMI(userssname!);
if (lastBMR != null) {
  BmiSingleRecord = [lastBMR];
} else {
  BmiSingleRecord = [];
}

  }

  
  Future<void> loadUsername() async {
    userssname = await SharedPreferenceHelper().getUsername();
    setState(() {});
  }

  Future<void> loadBMI() async {
    bmiList = await handler.RetrieveBMI(userssname!);
    setState(() {});
  }

  Future<void> loaddata() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    setState(() {
      loading = true;
    });
    username = await SharedPreferenceHelper().getUsername();
    if (username != null) {
      isMale = await getGender(username!);
      
    }
    setState(() {
      loading = false;
    });
  }

  Future<bool?> getGender(String username) async {
    final apiUrl = 'https://api.genderize.io/?name=$username';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['gender'] != null) {
          return data['gender'] == 'male';
        }
      }
      return null;
    } catch (e) {
      print('Error fetching gender: $e');
      return null;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
        double percentage = (CaloriesFilter / maxCaloriesPerDay) * 100; // Calculate the percentage


 FirebaseAnalytics.instance.setCurrentScreen(
      screenName: "HomeScreen",
      screenClassOverride: 'BaseHomeScreen',
    );
    double width = MediaQuery.of(context).size.width * 0.5;
    double remain = MediaQuery.of(context).size.width - width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFFF7F9FC),
        leading: Padding(
          padding: EdgeInsets.all(10),
          child: Card(
            child: GestureDetector(
                onTap: () async{
 await FirebaseAnalytics.instance.logEvent(
            name: "Logout",
            parameters: {
              "Action Button":"Logout",
              "Action Name":"LogOut"
            }
 );
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Prescreen();
                  }));
                },
                child: Icon(Icons.exit_to_app, size: 20, color: Colors.black)),
          ),
        ),
        actions: [
          
         Padding(
  padding: EdgeInsets.all(10),
  child: GestureDetector(
    onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return UserProfilesData();
      }));
    },
    child: CircleAvatar(
      backgroundColor: Colors.grey,
      child: _isLoading
          ? CircularProgressIndicator()
          : profiles.isNotEmpty? Container(
                    width: 150,
                    height: 150,
                    child: CircleAvatar(
                      backgroundColor: Color(0xFFF4F5F7),
                      
                      child:Container(
                        
                                                                          width:
                                                                              double.infinity,
                                                                          height: 200,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                                shape: BoxShape.circle,
                                                                            image:
                                                                                DecorationImage(
  
                                                                              image:
                                                                                  FileImage(File(profiles[0].path)),
                                                                              fit:
                                                                                  BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                        ),
                    ),
                  ):isMale!=null
                  ? Image.asset("Image/user_2.png")
                  : Image.asset("Image/user_1.png")
             
    ),
  ),
)

        ],
      ),
      body: SingleChildScrollView(
        controller: controller,
        child: BodyColumn(context),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        selectedItemColor: Colors.black,
        showSelectedLabels: true,
        currentIndex: 0,
        onTap: (value) {
          if (value == 1) { 
            Navigator.pushNamed(context, "/BMICalculator");
          } else if (value == 2) {
                       Navigator.pushNamed(context, "/CaloriesCalculator");

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
    floatingActionButton: FloatingActionButton(
  backgroundColor: Colors.black,
  elevation: 8.0,
  onPressed: () {
    if (controller.hasClients) {
      if (_isAtTop) {
        controller.animateTo(controller.position.maxScrollExtent,
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      } else {
        controller.animateTo(0,
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      }
      setState(() {
        _isAtTop = !_isAtTop;
      });
    }
  },
  child: _isAtTop ? Icon(Icons.arrow_downward) : Icon(Icons.arrow_upward),
),


    );
  }

  Column BodyColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Welcome , ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    username ?? 'Loading...',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text( DateFormat('dd MMM yyyy').format(DateTime.now().toLocal()), // Format the DateTime to display only the date
),
SizedBox(
  height: 20,
),
                  Text("Today Goals : 2500 Calories per day")
                ],
              ),
              Container(
                width: 100,
                height: 100,
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade300,
                  child: Image.asset(
                    "Image/Books.png",
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.all(20),
            child: Shadow()),
       
        SizedBox(
          height: 20,
        ),
         bmiList.isNotEmpty?   Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      width: 350,
                      height: 100,
                      child: DropdownButtonFormField<double>(
                        onSaved: (double? newValue) {
                          setState(() {
                            BMIfilter = newValue!;
                          });
                        },
                        isExpanded: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Select BMI",
                        ),
                        items: bmiList.map((BMI element) {
                          return DropdownMenuItem<double>(
                            value: element.bmi,
                            child: Text(element.bmi.toString()),
                          );
                        }).toList(),
                        onChanged: (double? value) {
                          setState(() {
                            BMIfilter = value!;
                          });
                        },
                      ),
                    ),
                    Column(
        children: [
          SizedBox(
            height: 20,
          ),
        bmiList.isNotEmpty?  Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Underweight',
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              Text(
                'Normal',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              Text(
                'Overweight',
                style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
              ),
              Text(
                'Obese',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ],
          ):SizedBox.shrink(),
          SizedBox(
            height: 20,
          ),
       SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0,
                maximum: 40,
                showLabels: false,
                showTicks: false,
                axisLineStyle: AxisLineStyle(
                  thickness: 20, // Adjust the thickness
                  cornerStyle: CornerStyle.bothFlat,
                  color: Colors.transparent, // Set color to transparent
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
                    value:BMIfilter,
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
                        Text(
                          "Your BMI:",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "SegoeUIBold",
                          ),
                        ),
                        Text(
                          '${BMIfilter.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "SegoeUIBold",
                          ),
                        ),
                        Text(
                          _getBMIStatus(BMIfilter),
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
          SizedBox(
  height: 30,
),
        ],
      ),

                  ],
                ),
              ):   SizedBox.shrink(),
        
 CaloriesList.isNotEmpty? Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      width: 300,
                      height: 100,
                      child: DropdownButtonFormField<double>(
                        onSaved: (double? newValue) {
                          setState(() {
                            CaloriesFilter= newValue!;
                          });
                        },
                        isExpanded: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Select Calories",
                        ),
                        items: CaloriesList.map((CaloriesData element) {
                          return DropdownMenuItem<double>(
                            value: element.bmr,
                            child: Text(element.bmr.toString()),
                          );
                        }).toList(),
                        onChanged: (double? value) {
                          setState(() {
                            CaloriesFilter = value!;
                         percentage=  CaloriesFilter / maxCaloriesPerDay * 100; // Calculate the percentage

                          });
                        },
                      ),
                    ),
                    Center(
        child: Stack(
alignment: Alignment.center,
children: [
  SfRadialGauge(
    axes: <RadialAxis>[
      RadialAxis(
        minimum: 0,
        maximum: 100,
        showLabels: false,
        showTicks: false,
        startAngle: 270,
        endAngle: 270,
        axisLineStyle: AxisLineStyle(
          thickness: 0.05,
          color: const Color.fromARGB(100, 0, 169, 181),
          thicknessUnit: GaugeSizeUnit.factor,
        ),
        pointers: <GaugePointer>[
          RangePointer(
            value: percentage.clamp(0, 100), // Clamp the value between 0 and 100
            width: 0.95,
            pointerOffset: 0.05,
            sizeUnit: GaugeSizeUnit.factor,
          )
        ],
      ),
    ],
  ),
  Text(
    '${percentage.toStringAsFixed(1)}%',
    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  ),
],
        ),
      ),
      Text("Current Calories is ${CaloriesFilter}")
                  ],
                ),
              ): SizedBox.shrink(),


     
        SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
            padding: EdgeInsets.all(20),
            child: Text("Explore More",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold))),
        SizedBox(
          height: 10,
        ),
        ExploreFeature()
      ],
    );
  }

  Column Shadow() {
    return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
              Card(
elevation: 0, // Set elevation to 0 to prevent double shadow effect
child: ClipRRect(
  borderRadius: BorderRadius.circular(25),
  child: Container(
    width: 180,
    height: 200,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      boxShadow: [
        BoxShadow(
          color: Colors.white.withOpacity(0.2),
          spreadRadius: -5,
          blurRadius: 20, // Adjust blur radius as needed
          offset: Offset(-5, -5),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: -2,
          blurRadius: 7, // Adjust blur radius as needed
          offset: Offset(2, 2),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1), // Adjust opacity as needed
          ),
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(30),
                width: double.infinity,
                height: double.infinity,
                color:  Color(0xFFFF6950).withOpacity(0.2), // Adjust opacity as needed
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Text("BMI",
                              style: TextStyle(
                                  color: Color(0xFFFF6950),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          Spacer(),
                          ClipRRect(
                            child: Container(
                              width: 30,
                              height: 30,
                              child: Image.asset(
                                "Image/Fire.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color(0xFFFF6950),
                              width: 10),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                            child: BmiSingleRecord.isEmpty
                                ? Text("0")
                                : Text(BmiSingleRecord[0].bmi.toString())),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ),
  ),
),
),

                    SizedBox(
                      width: 10,
                    ),
                Card(
elevation: 0, // Set elevation to 0 to prevent double shadow effect
child: ClipRRect(
  borderRadius: BorderRadius.circular(25),
  child: Container(
    width: 150,
    height: 180,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      boxShadow: [
        BoxShadow(
          color: Colors.white.withOpacity(0.2),
          spreadRadius: -5,
          blurRadius: 20, // Adjust blur radius as needed
          offset: Offset(-5, -5),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: -2,
          blurRadius: 7, // Adjust blur radius as needed
          offset: Offset(2, 2),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1), // Adjust opacity as needed
          ),
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(30),
                width: double.infinity,
                height: double.infinity,
                color:  Colors.lightBlue.withOpacity(0.2), // Adjust opacity as needed
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                     const Padding(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Text("Calories",
                                style: TextStyle(
                                    color: Color(0xFFFF6950),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            Spacer(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          children: [
                            CaloriesSingleRecord.isEmpty ? 
                              const Text("0",
                                style: TextStyle(
                                  color: Color(0xFFFF6950),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)) : 
                              Text(CaloriesSingleRecord[0].bmr.toString()),
                            const Spacer(),
                          ],
                        ),
                      ),
                      Container(
                        width: 150,
                        height: 150,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 130,
                                child: Image.asset(
                                  "Image/Running.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  ),
),
),

                  ],
                ),
              )
            ],
          );
  }
}


// Define a class to represent BMI chart data
class BMIChartData {
  final double value;

  BMIChartData(this.value);
}

// Inside your _HomePageState class

// Define a list to hold BMI chart data
List<BMIChartData> bmiChartData = [];