import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:msd_project_food_diary/Data/DatabaseHelper.dart';
import 'package:msd_project_food_diary/Login/Login.dart';
import 'package:msd_project_food_diary/Model/UsersModel.dart';
import 'package:msd_project_food_diary/ResetPassword/ResetPass.dart';
import 'package:msd_project_food_diary/firebase_options.dart';
import 'package:sqflite/sqflite.dart';



class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    return MaterialApp(

      debugShowCheckedModeBanner: false,
      home: MyRegister(),
    );
  }
}

class MyRegister extends StatefulWidget {
  
  
  const MyRegister({super.key});

  @override
  State<MyRegister> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> with SingleTickerProviderStateMixin {

  late final AnimationController controller;
  bool ischeck= false;
  String usernames = "";
  String passwords="";
  String cfmpasswords="";
  
    late Databasehelper handler;
    final formkeys = GlobalKey<FormState>();
    final TextEditingController username =  TextEditingController();
        final TextEditingController password = TextEditingController();

    final TextEditingController cfmpassword = TextEditingController();
    List<Users>registere=[];
    //list of register

    
@override
  void initState() {

    handler=Databasehelper();
     handler.InitiDb();
    // TODO: implement initState
    super.initState();    
    controller=AnimationController(vsync: this);
    loadData();
    LoadFirebase();
  }
  Future<void>LoadFirebase()async{
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);  
  }
  Future<void>loadData()async{
    registere=await handler.RetriveData();
    setState(() {
      
    });
  }
FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Padding(
        padding: EdgeInsets.fromLTRB(10, 100, 10, 10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text("Register New Account ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20,), textAlign: TextAlign.center,),
              SizedBox(
                height: 50,
              ),
              Center(
                child: LottieBuilder.network("https://lottie.host/e201a0af-01a1-4ccf-bc02-5b92a67a6725/4cW3wVIyZd.json", animate: true,repeat: true,width: 200, height: 200, onLoaded: (p0) {
                  controller.duration=p0.duration;
                  controller.forward();
                },),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: formkeys,
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
                    ),
                       Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Container(
                        width: 300,
                        height: 50,
                        child: TextFormField(
                                                  autovalidateMode: AutovalidateMode.onUserInteraction,
validator: (value) {
  if( value==null || value.isEmpty){
return "Please key in CfmPassword";
  }
  return null;
},
                          onSaved: (newValue) {
                            cfmpasswords=newValue!;
                          },
                          controller: cfmpassword,
                          
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
                            labelText: "CfmPassword",
                            
                            border: OutlineInputBorder()
                          ),
                        )),
                    ),
                    
                    Padding(
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
                    
                    Card(
                      elevation: 10.0,
                      child: Container(
                        width: 300,
                        height: 50,
                        child: ElevatedButton(onPressed: ()async{
                          formkeys.currentState!.save();
                          if(passwords!=cfmpasswords){
                            showDialog(context: context, builder:(context){
                              return AlertDialog(
                                content: Text("Password do not matched"),
                                actions: <Widget>[
                                  ElevatedButton(onPressed: (){
                                    Navigator.pop(context);
                                  }, child: Text("close"))
                                ],
                              );
                            });
                          }else{
                            if (formkeys.currentState!.validate()) {
                      Users reg = Users(username: usernames, password: passwords);
                      int existingUsersCount = await handler.PreventRegisterAccount(reg);
                    
                      if (existingUsersCount > 0) {
                        setState(() {
                          loadData();
                        });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Insert Failed User Already Exsited")),
                          );
                      } else {
                        // Username is unique, proceed with registration
                         await handler.InsertRecords(reg);
                        setState(() {
                          loadData();
                        });
                         Navigator.push(context, MaterialPageRoute(builder: (context){
                          return Login();
                         }));
                         await analytics.logEvent(
                          name: "Register",
                          parameters: {
                            "Register_Screen":"Register Sucessfully"
                          }
                         );
                      }
                    }
                    
                     
                          }
                         
                          
                          
                        }, child: Text("Register", style: TextStyle(
                          color:Colors.white,
                        ),), style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black
                        ),),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Have Account ?", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
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
                                                  return Login();
                                                }));
                              }, child:Text("Login"), style: ElevatedButton.styleFrom(
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