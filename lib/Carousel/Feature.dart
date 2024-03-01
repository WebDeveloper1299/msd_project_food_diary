import 'package:flutter/material.dart';
import 'package:msd_project_food_diary/ResetPassword/MainFolder/BMICalculator.dart';
import 'package:msd_project_food_diary/ResetPassword/MainFolder/CaloriesCalculator.dart';
import 'package:msd_project_food_diary/ResetPassword/MainFolder/DisplayPicture.dart';

class  ExploreFeature extends StatelessWidget {
  const  ExploreFeature({super.key});

  @override
  Widget build(BuildContext context) {  
    double width= MediaQuery.of(context).size.width*0.5;
    double remain= MediaQuery.of(context).size.width - width;

    return Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Card(
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        color: Colors.white,
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              child: Row(
                                children: [
                                   Container(
                                width: width,
                                height: double.infinity,
                                child: Image.asset("Image/BMICarousel.jpg", fit: BoxFit.cover,)),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Container(
                                     
                                           width: 147,
                                           height: 150,
                                                            child: SingleChildScrollView(
                                                              child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 20),
                                        child: Text("Want to know your BMI ?", textAlign: TextAlign.center,)),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      Center(
                                        child: ElevatedButton(onPressed: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context){
                                        return BMICalculatorScreen();
                                      }));
                                        }, child:Text("Find out"), style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFFFF8474)
                                        ),),
                                      )
                                    ],
                                                              ),
                                                            )),
                                  ),
                                ],
                              ),
                            )
                           
                          
                          ],
                        ),
                        
                      ),
                    ),
                  )
        
                ],
              ),
            
               SizedBox(
                height: 30,
              ),
               Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Card(
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        color: Colors.white,
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              child: Row(
                                children: [
                                   Container(
                                width: width,
                                height: double.infinity,
                                child: Image.asset("Image/CaptureDairy.jpg", fit: BoxFit.cover,)),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Container(
                                     
                                           width: 147,
                                           height: 150,
                                                            child: SingleChildScrollView(
                                                              child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 20),
                                        child: Text("Want to try caputure food in your dairy app  ?", textAlign: TextAlign.center,)),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      Center(
                                        child: ElevatedButton(onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context){
                                        return DisplayPictureScreen(imagePath: '');
                                      }));

                                        }, child:Text("Try out"), style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFFFF8474)
                                        ),),
                                      )
                                    ],
                                                              ),
                                                            )),
                                  ),
                                ],
                              ),
                            )
                           
                          
                          ],
                        ),
                        
                      ),
                    ),
                  )
        
                ],
              ),
              SizedBox(
                height: 20,
              ),
                 Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Card(
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        color: Colors.white,
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              child: Row(
                                children: [
                                   
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Container(
                                     
                                           width: 147,
                                           height: 150,
                                                            child: SingleChildScrollView(
                                                              child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 20, left: 10),
                                        child: Text("Want to find out carlories intake  ?", textAlign: TextAlign.center,)),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      Center(
                                        child: ElevatedButton(onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context){
                                        return CaloriesCalculate();
                                      }));
                                        }, child:Text("Browse"), style: ElevatedButton.styleFrom(
                                          backgroundColor:  Color(0xFFFF8474)
                                        ),),
                                      )
                                    ],
                                                              ),
                                                            )),
                                  ),
                                  Container(
                                width: width,
                                height: double.infinity,
                                child: Image.asset("Image/CaloriesFinder.jpg", fit: BoxFit.cover,)),
                                ],
                              ),
                            )
                           
                          
                          ],
                        ),
                        
                      ),
                    ),
                  )
        
                ],
              ),
              
            ],
          ),
        );
  }
}