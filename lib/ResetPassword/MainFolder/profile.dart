import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:msd_project_food_diary/Data/DatabaseHelper.dart';
import 'package:msd_project_food_diary/Data/SharedPreferences/SharedPreferencesHelper.dart';
import 'package:msd_project_food_diary/Login/Login.dart';
import 'package:msd_project_food_diary/Model/Bmi.dart';
import 'package:msd_project_food_diary/Model/Calories.dart';
import 'package:msd_project_food_diary/Model/UserGathering.dart';
import 'package:msd_project_food_diary/Model/profileimage.dart';
import 'package:msd_project_food_diary/ResetPassword/MainFolder/Home.dart';
import 'package:msd_project_food_diary/ResetPassword/MainFolder/UserProfile.dart';

class UserProfileApp extends StatelessWidget {
  const UserProfileApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserProfilesData(),
    );
  }
}

class UserProfilesData extends StatefulWidget {
  const UserProfilesData({Key? key}) : super(key: key);

  @override
  State<UserProfilesData> createState() => _UserProfilesDataState();
}

class _UserProfilesDataState extends State<UserProfilesData> {
  late Databasehelper handle;
  List<ProfileImageModel> profile = [];
  List<UserProfile> userprofile = [];
  bool? isMale = true;
  bool isloading = true;

  List<BMI> BmiSingleRecord = [];
  List<CaloriesData> CaloriesSingleRecord = [];
  String? username = "";

  @override
  void initState() {
    super.initState();
    handle = Databasehelper();
    handle.InitiDb();
    LoadUserData();
  }

  Future<void> LoadUserData() async {
    username = await SharedPreferenceHelper().getUsername();
    if (username != null) {
      isMale = await getGender(username!);
    }
    loadData();
    RetrieveUserprofile();
    loadLastRecordsBMI();
    loadLastRecordsCalories();
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

  Future<void> loadLastRecordsBMI() async {
    final lastBMR = await handle.RetrieveLastBMI(username!);
    if (lastBMR != null) {
      BmiSingleRecord = [lastBMR];
    } else {
      BmiSingleRecord = [];
    }
  }

  Future<void> loadLastRecordsCalories() async {
    final lastBMR = await handle.retrieveLastBMR(username!);
    if (lastBMR != null) {
      CaloriesSingleRecord = [lastBMR];
    } else {
      CaloriesSingleRecord = [];
    }
  }

  Future<void> loadData() async {
    profile = await handle.RetrieveProfileImage(username);
    setState(() {
      isloading = false;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (profile.isNotEmpty) {
        await handle.updateProfileImage(ProfileImageModel(
            id: profile[0].id, username: username!, path: pickedFile.path));
        setState(() {
          loadData();
        });
      } else {
        await handle.InsertProfileImage(
            ProfileImageModel(username: username!, path: pickedFile.path));
      }
      setState(() {
        loadData();
      });
    } else {
      print('No image selected.');
    }
  }

  Future<void> RetrieveUserprofile() async {
    userprofile = await handle.RetriveProfile(username!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Home();
            }));
          },
          child: Icon(Icons.arrow_back, size: 20, color: Colors.black),
        ),
        centerTitle: true,
        title: Text(
          "My Profile",
          style: TextStyle(
              color: Color(0xFF2B2B2B), fontSize: 20, fontFamily: 'Roboto'),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    child: CircleAvatar(
                      backgroundColor: Color(0xFFF4F5F7),
                      child: Center(
                        child: isloading
                            ? CircularProgressIndicator()
                            : profile.isEmpty
                                ? isMale!=null
                                    ? Image.asset(
                                        "Image/user_2.png",
                                        fit: BoxFit.contain,
                                        width: 100,
                                        height: 100,
                                      )
                                    : Image.asset(
                                        "Image/user_1.png",
                                        fit: BoxFit.contain,
                                        width: 100,
                                        height: 100,
                                      )
                                : Container(
                                    width: double.infinity,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: FileImage(File(profile[0].path)),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Container(
                      width: 100,
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            username.toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Students",
                            style:
                                TextStyle(color: Color(0xFF9EA3B0)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Row(
                              children: [
                                Text("Edit Picture"),
                                SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                    onTap: () async {
                                      await _pickImage();
                                    },
                                    child: Icon(Icons.edit,
                                        size: 20,
                                        color: Color(0xFF9EA3B0)))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Card(
                    child: Container(
                      width: 50,
                      height: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) {
                                        return UserProfiles();
                                      }));
                            },
                            child: Icon(Icons.edit_document,
                                size: 20,
                                color: Color(0xFFD3D3D3)),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Card(
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      child: Row(
                        children: [
                      
                          userprofile.isNotEmpty
                              ? SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Container(
                                    width: 300,
                                    height: 200,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 100,
                                          child: Image.asset("Image/Contact.jpg",fit: BoxFit.cover,),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            
                                          
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                
                                                Text("Name:",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(userprofile[0]
                                                    .username
                                                    .toString())
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Text("Age:",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(userprofile[0]
                                                    .age
                                                    .toString())
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Text("Height:",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(userprofile[0]
                                                    .height
                                                    .toString())
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Text("Weight:",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(userprofile[0]
                                                    .weight
                                                    .toString())
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Padding(
                                padding:EdgeInsets.only(left: 90, top: 20) ,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Center(
                                          child: Container(
                                            color: Color(0xFFFF6839),
                                            width: 140,
                                            height: 40,
                                            child: Center(
                                              child: Text(
                                                "Actions Needed",
                                                style:
                                                    TextStyle(color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text("Profile Incomplete "),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                              )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Dashboard",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Card(
                  child: Container(
                    width: double.infinity,
                    height: 120,
                    color: Color(0xFFF4F5F7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 30, top: 20, right: 20, bottom: 0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: [
                                  Text("Calories",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontFamily: 'Roboto',
                                          fontSize: 20)),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  CaloriesSingleRecord.isEmpty
                                      ? Text("0",
                                          style: TextStyle(
                                              color: Color(0xFF8C6543)))
                                      : Text(
                                          CaloriesSingleRecord[0]
                                              .bmr
                                              .toString(),
                                          style: TextStyle(
                                              color: Color(0xFF8C6543)))
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Home();
                                  }));
                                },
                                child: Text(
                                  "View More",
                                  style: TextStyle(color: Colors.black),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFFBD337)),
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                        Column(
                          children: <Widget>[
                            Container(
                              width: 100,
                              height: 100,
                              child: Image.asset("Image/Foods1.png",
                                  fit: BoxFit.fitWidth),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Card(
                  child: Container(
                    width: double.infinity,
                    height: 120,
                    color: Color(0xFFF4F5F7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 30, top: 20, right: 20, bottom: 0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: [
                                  Text("BMI",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontFamily: 'Roboto',
                                          fontSize: 20)),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  BmiSingleRecord.isEmpty
                                      ? Text("0",
                                          style: TextStyle(
                                              color: Color(0xFF8C6543)))
                                      : Text(
                                          BmiSingleRecord[0]
                                              .bmi
                                              .toString(),
                                          style: TextStyle(
                                              color: Color(0xFF8C6543)))
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Home();
                                  }));
                                },
                                child: Text(
                                  "View More",
                                  style: TextStyle(color: Colors.black),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFFBD337)),
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                        Column(
                          children: <Widget>[
                            Container(
                              width: 100,
                              height: 100,
                              child: Image.asset("Image/Calories.png",
                                  fit: BoxFit.cover),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "My Account",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Login();
                    }));
                  },
                  child: Text(
                    "Switch to Other Account",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF769EFF)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Login();
                    }));
                  },
                  child: Text(
                    "Log Out",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFFFFCEBE)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
