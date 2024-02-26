
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:msd_project_food_diary/Data/DatabaseHelper.dart';
import 'package:msd_project_food_diary/Data/SharedPreferences/SharedPreferencesHelper.dart';
import 'package:msd_project_food_diary/Model/Username.dart';
import 'package:msd_project_food_diary/Model/UsersModel.dart';
import 'package:msd_project_food_diary/Register/Register.dart';
import 'package:msd_project_food_diary/ResetPassword/MainFolder/Home.dart';
import 'package:msd_project_food_diary/ResetPassword/ResetPass.dart';


class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LogginIn(),
    );
  }
}

class LogginIn extends StatefulWidget {
  const LogginIn({super.key});

  @override
  State<LogginIn> createState() => _LogginInState();
}

class _LogginInState extends State<LogginIn> with SingleTickerProviderStateMixin{
  String usernames="";
  bool ischeck=false;
  String passwords="";
  final TextEditingController username= TextEditingController();
    final TextEditingController password= TextEditingController();

  late final AnimationController controller;
 late Databasehelper handler;
    final formkey = GlobalKey<FormState>();
    List<Users>logins=[];
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    handler=Databasehelper();
    handler.InitiDb();
    controller= AnimationController(vsync: this);

    loadData();


  }

  Future<void>loadData()async{
    logins = await handler.RetriveData();
    setState(() {
      
    });
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
              Text("Login Account ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20,), textAlign: TextAlign.center,),
              SizedBox(
                height: 50,
              ),
              Center(
                child: LottieBuilder.network("https://lottie.host/e6f3f807-b47d-4383-90a6-499aa8010b73/5qSIheOQfP.json", animate: true,repeat: true,width: 200, height: 200, onLoaded: (p0) {
                  controller.duration=p0.duration;
                  controller.forward();
                },),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: formkey,
                child: Column(
                  children: <Widget>[
                     Padding(
                      padding: EdgeInsets.only(bottom: 30, top: 20),
                      child: Container(
                        width: 300,
                        height: 50,
                        child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: username,
                          onSaved: (newValue) {
                          usernames=newValue!;
                          },
                          validator: (value) {
                            if(value==null || value.isEmpty){
                              return "Please key in username";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Username",
                            border: OutlineInputBorder()
                          ),
                        )),
                    ),
                      Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: Container(
                        width: 300,
                        height: 50,
                        child: TextFormField(
                                                  autovalidateMode: AutovalidateMode.onUserInteraction,

                          onSaved: (newValue) {
                            passwords=newValue!;
                          },
                        controller: password,
                        validator: (value) {
                          if(value==null || value.isEmpty){
                            return "Please key in password";
                          }
                          return null;
                        },
                          obscureText: ischeck? true:false,
                          decoration: InputDecoration(
                          
                            suffixIcon: ischeck?GestureDetector(
                              onTap: (){
                                setState(() {
                                  ischeck=false;
                                });
                              },
                              child: Icon( Icons.visibility_off, color: Colors.black,),):  GestureDetector(
                              onTap: (){
                                setState(() {
                                  ischeck=true;
                                });
                              },
                              child: Icon( Icons.visibility,color: Colors.black,)),
                            labelText: "Password",
                            border: OutlineInputBorder()
                          ),
                        )),
                    ),   Padding(
                      padding: EdgeInsets.only(right: 40, bottom: 20),
                      child: Row(
                        children: <Widget>[
                          Spacer(),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return Reset();
                              }));
                            },
                            child: Text("Forget Password?", style: TextStyle(color: Colors.grey[600]),))
                        ],
                      ),
                    ),
                     
                    Container(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(onPressed: ()async{
                        formkey.currentState!.save();
                     
                        if (formkey.currentState!.validate()) {
  Users login = Users(username: usernames, password: passwords);
  int existingUsersCount = await handler.CheckifUserExisted(login);
  int existingUserPassword = await handler.CheckifPasswordExisted(login);

  if (existingUsersCount == 0) {
    // User does not exist
    setState(() {
      loadData();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("User not registered yet")),
    );
  } else if (existingUserPassword == 0) {
    // Password is incorrect
    setState(() {
      loadData();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Password incorrect")),
    );
  } else {
    setState(() {
      loadData();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Login successfully")),
    );
    await handler.insertUsername(Username(username: usernames));
     String username=await handler.getUsername(usernames);
     await SharedPreferenceHelper().setUsername(username);
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return Home();
     }));
  }
}    }, child: Text("Login", style: TextStyle(
                        color: Colors.white
                      ),), style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black
                      ),),
                    ),
                     SizedBox(
                      height: 20,
                    ),
                    Text("New Here ?", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                    SizedBox(
                      height: 10,
                    ),
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
                              child: ElevatedButton(onPressed: (){
                                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                                  return Register();
                                                }));
                              }, child:Text("Register"), style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent
                              ),),
                            ),
                          )
                        ],
                      ),
                    )

                  ],
                ),
              )
        
            ],
          ),
        ),
      ),

    );
  }
}