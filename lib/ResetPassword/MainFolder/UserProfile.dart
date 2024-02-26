import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:msd_project_food_diary/Data/DatabaseHelper.dart';
import 'package:msd_project_food_diary/Data/SharedPreferences/SharedPreferencesHelper.dart';
import 'package:msd_project_food_diary/Model/UserGathering.dart';
import 'package:msd_project_food_diary/Model/profileimage.dart';
import 'package:msd_project_food_diary/ResetPassword/MainFolder/Home.dart';
import 'package:msd_project_food_diary/ResetPassword/MainFolder/profile.dart';
import 'package:http/http.dart' as http;



class UserProfiles extends StatefulWidget {
  const UserProfiles({Key? key}) : super(key: key);

  @override
  State<UserProfiles> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfiles> {
  final TextEditingController username = TextEditingController();
    final TextEditingController usernameUpdate = TextEditingController();

  final TextEditingController age = TextEditingController();
    final TextEditingController ageupdate = TextEditingController();

  final TextEditingController weight = TextEditingController();
    final TextEditingController weightupdate = TextEditingController();

  final TextEditingController height = TextEditingController();
    final TextEditingController heightupdate = TextEditingController();

  final formkey = GlobalKey<FormState>();
    final formkeyUpdate = GlobalKey<FormState>();

  late Databasehelper handler;
  List<UserProfile> userprofile = [];
  List<ProfileImageModel> profile = [];
  late String? Username;
  
  bool? isMale = true;
  bool isloading = true;

  @override
  void dispose() {
    age.dispose();
    weight.dispose();
    height.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    handler = Databasehelper();
    handler.InitiDb();
    loadData().then((value) {
      loadUserImage();
      
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

  Future<void> loadUserImage() async {
    profile = await handler.RetrieveProfileImage(Username);
    setState(() {});
  }

  Future<void> loadUserProfile() async {
    userprofile = await handler.RetriveProfile(Username!);
    setState(() {
      ageupdate.text = userprofile.isEmpty ? "" : userprofile[0].age.toString();
      weightupdate.text = userprofile.isEmpty ? "" : userprofile[0].weight.toString();
      heightupdate.text = userprofile.isEmpty ? "" : userprofile[0].height.toString();
    });
  }

  Future<void> loadData() async {
    Username = await SharedPreferenceHelper().getUsername();
    
     if (Username != null) {
      isMale = await getGender(Username!);
         setState(() {
      isloading = false;
    });
    }
    loadUserProfile();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (profile.isNotEmpty) {
        await handler.updateProfileImage(ProfileImageModel(
            id: profile[0].id, username: Username!, path: pickedFile.path));
      } else {
        await handler.InsertProfileImage(
            ProfileImageModel(username: Username!, path: pickedFile.path));
      }
      setState(() {
        loadData();
        loadUserImage();
      });
    } else {
      print('No image selected.');
    }
  }

  Widget newUserProfile() {
    return SingleChildScrollView(
      child: Form(
        key: formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
       Center(
                        child: Stack(
                          children: [
                           
isloading
                              ? Center(child: CircularProgressIndicator())
                              : profile.isEmpty
                                  ? isMale!=null
                                      ? Image.asset(
                                          "Image/user_2.png",
                                          fit: BoxFit.contain,
                                          width: double.infinity,
                                          height: 200,
                                        )
                                      : Image.asset(
                                          "Image/user_1.png",
                                          fit: BoxFit.contain,
                                          width: double.infinity,
                                          height: 200,
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
                                     Container(width: double.infinity, height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                                                          color: Colors.black38,

                            ),
                          
                            child: Center(child: GestureDetector(
                              onTap: (){
                                _pickImage();
                              },
                              child: Icon(Icons.edit, size: 20, color: Colors.white,))),
                            ),
                          ],
                        ),
                      ),


            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "New Profile",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Username"),
                    SizedBox(height: 20),
                    Container(
                      width: 150,
                      height: 50,
                      child: TextFormField(
                        validator: (value) =>
                            value!.isEmpty ? "Username is required" : null,
                        controller: username,
                        decoration: InputDecoration(
                          labelText: "Username",
                            border: OutlineInputBorder()),
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Age"),
                    SizedBox(height: 20),
                    Container(
                      width: 150,
                      height: 50,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value!.isEmpty ? "Age is required" : null,
                        controller: age,
                        decoration: InputDecoration(
                            labelText: "Age",
                            border: OutlineInputBorder()),
                      ),
                    )
                  ],
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text("Weight in (kg)"),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                width: 400,
                height: 50,
                child: TextFormField(
                  validator: (value) =>
                      value!.isEmpty ? "Weight is required" : null,
                  controller: weight,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Weight in Kg",
                      border: OutlineInputBorder()),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text("Height in (cm)"),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                width: 400,
                height: 50,
                child: TextFormField(
                  validator: (value) =>
                      value!.isEmpty ? "Height is required" : null,
                  controller: height,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Height in cm",
                      border: OutlineInputBorder()),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                width: 400,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (formkey.currentState!.validate()) {
                      if (Username != username.text) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            actions: [
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("Close"),
                              )
                            ],
                            content: Text("Username must be matched"),
                          ),
                        );
                      } else {
                        await handler.InsertNewProfie(UserProfile(
                            username: Username!,
                            weight: double.parse(weight.text),
                            height: int.parse(height.text),
                            age: int.parse(age.text)));
                        setState(() {});
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserProfilesData()));
                      }
                    }
                  },
                  child: Text("Complete"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                width: 400,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    username.clear();
                    age.clear();
                    weight.clear();
                    height.clear();
                    setState(() {});
                  },
                  child: Text("Clear"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white60,
        leading: GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context){
            return UserProfilesData();
          })),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Card(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Icon(Icons.arrow_back, size: 20, color: Colors.black),
              ),
            ),
          ),
        ),
      ),
      body: userprofile.isEmpty ? newUserProfile() : SingleChildScrollView(
        child: Form(
          key: formkeyUpdate,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: profile.isEmpty || profile[0].path.isEmpty
                            ? null
                            : DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(profile[0].path)),
                              ),
                      ),
                    ),
                    Container(
                      width: 200,
                      height: 200,
                      child: Center(
                        child: Card(
                            color: Colors.black,
                            child: GestureDetector(
                                onTap: () {
                                  _pickImage();
                                },
                                child:
                                    Icon(Icons.edit, size: 25, color: Colors.white))),
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text("Update Profile",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Username"),
                      SizedBox(height: 20),
                      Container(
                        width: 150,
                        height: 50,
                        child: TextFormField(
                          validator: (value) =>
                              value!.isEmpty ? "Username is required" : null,
                          controller: usernameUpdate,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Username "),
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Age"),
                      SizedBox(height: 20),
                      Container(
                        width: 150,
                        height: 50,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value!.isEmpty ? "Age is required" : null,
                          controller: ageupdate,
                          decoration: InputDecoration(
                              labelText: "Age",
                              border: OutlineInputBorder()),
                        ),
                      )
                    ],
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text("Weight in (kg)"),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  width: 400,
                  height: 50,
                  child: TextFormField(
                    validator: (value) =>
                        value!.isEmpty ? "Weight is required" : null,
                    controller: weightupdate,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Weight in Kg",
                        border: OutlineInputBorder()),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text("Height in (cm)"),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  width: 400,
                  height: 50,
                  child: TextFormField(
                    validator: (value) =>
                        value!.isEmpty ? "Height is required" : null,
                    controller: heightupdate,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Height in cm",
                        border: OutlineInputBorder()),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  width: 400,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formkeyUpdate.currentState!.validate()) {
                        if (Username!=usernameUpdate.text) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              actions: [
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("Close"),
                                )
                              ],
                              content: Text("Username must be matched"),
                            ),
                          );
                        } else {
                          await handler.UpdateUserProfile(UserProfile(
                              username: Username!,
                              weight:double.parse(weightupdate.text),
                              height:int.parse(heightupdate.text),
                              age:int.parse(ageupdate.text),
                              id: userprofile[0].id));
                          setState(() {});
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserProfilesData()));
                        }
                      }
                    },
                    child: Text("Update"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  width: 400,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        username.text = ""; // Clear username controller
                        ageupdate.clear(); // Clear age controller
                        heightupdate.clear(); // Clear height controller
                        weightupdate.clear(); // Clear weight controller
                      });
                    },
                    child: Text("Clear"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red),
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
