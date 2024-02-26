import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:msd_project_food_diary/Data/DatabaseHelper.dart';
import 'package:msd_project_food_diary/Model/UsersModel.dart';
import 'package:msd_project_food_diary/Register/Register.dart';
import '../Login/Login.dart';

class Reset extends StatelessWidget {
  const Reset({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ResetPassword(),
    );
  }
}

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool isCheck = false;
  late Databasehelper handler;
  String username = "";
  String password = "";
  String confirmPassword = "";
  final formKey = GlobalKey<FormState>();
  List<Users> resets = [];
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    handler = Databasehelper();
    handler.InitiDb();
    controller = AnimationController(vsync: this);
    loadData();
  }

  Future<void> loadData() async {
    resets = await handler.RetriveData();
    setState(() {});
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Padding(
        padding: EdgeInsets.fromLTRB(10, 100, 10, 10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(
                "Resetting Password? ",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50),
              Center(
                child: LottieBuilder.network(
                  "https://lottie.host/e4089bd7-3ecf-4681-aa88-6041a4932139/4s9QGUQFVC.json",
                  animate: true,
                  repeat: true,
                  width: 200,
                  height: 200,
                  onLoaded: (p0) {
                    controller.duration = p0.duration;
                    controller.forward();
                  },
                ),
              ),
              SizedBox(height: 20),
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 30, top: 20),
                      child: Container(
                        width: 300,
                        height: 50,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: usernameController,
                          onSaved: (newValue) {
                            username = newValue!;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter username";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Username",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: Container(
                        width: 300,
                        height: 50,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onSaved: (newValue) {
                            password = newValue!;
                          },
                          controller: passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter password";
                            }
                            return null;
                          },
                          obscureText: isCheck ? true : false,
                          decoration: InputDecoration(
                            suffixIcon: isCheck
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isCheck = false;
                                      });
                                    },
                                    child: Icon(Icons.visibility_off, color: Colors.black),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isCheck = true;
                                      });
                                    },
                                    child: Icon(Icons.visibility, color: Colors.black),
                                  ),
                            labelText: "Password",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Container(
                        width: 300,
                        height: 50,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter confirm password";
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            confirmPassword = newValue!;
                          },
                          controller: confirmPasswordController,
                          obscureText: isCheck ? true : false,
                          decoration: InputDecoration(
                            suffixIcon: isCheck
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isCheck = false;
                                      });
                                    },
                                    child: Icon(Icons.visibility_off, color: Colors.black),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isCheck = true;
                                      });
                                    },
                                    child: Icon(Icons.visibility, color: Colors.black),
                                  ),
                            labelText: "Confirm Password",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 40, bottom: 20),
                      child: Row(
                        children: <Widget>[
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return Register();
                              }));
                            },
                            child: Text("New Account ?", style: TextStyle(color: Colors.grey[600])),
                          )
                        ],
                      ),
                    ),
                    Card(
                      elevation: 10.0,
                      child: Container(
                        width: 300,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            formKey.currentState!.save();
                            if (password != confirmPassword) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text("Passwords do not match"),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Close"),
                                      )
                                    ],
                                  );
                                },
                              );
                            } else {
                              if (formKey.currentState!.validate()) {
                                Users user = Users(username: username, password: password);
                                int userExistsCount = await handler.CheckifUserExisted(user);
                                if (userExistsCount > 0) {
                                  await handler.UpdatePassword(user);
                                  setState(() {
                                    loadData();
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Password updated successfully")),
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Login()),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("User does not exist")),
                                  );
                                }
                              }
                            }
                          },
                          child: Text(
                            "Reset",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Have an Account ?",
                      style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(bottom: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Card(
                            elevation: 10.0,
                            child: Container(
                              width: 300,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Login()),
                                  );
                                },
                                child: Text("Login"),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
