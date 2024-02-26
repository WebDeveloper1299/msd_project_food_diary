import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:msd_project_food_diary/Intro_Page/IntroPage1.dart';
import 'package:msd_project_food_diary/Intro_Page/IntroPage2.dart';
import 'package:msd_project_food_diary/Intro_Page/IntroPage3.dart';
import 'package:msd_project_food_diary/Register/Register.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main()async{
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);  
runApp(const Prescreen());

}

class Prescreen extends StatelessWidget {
  const Prescreen({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PreLoading(),
    );
  }
}

class PreLoading extends StatefulWidget {
  const PreLoading({super.key});

  @override
  State<PreLoading> createState() => _PreLoadingState();
}

class _PreLoadingState extends State<PreLoading> {
  bool onlastpage =false;
  int pagetrack=0;
  
  late PageController controller = PageController(initialPage: 0);
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    analytics.setAnalyticsCollectionEnabled(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
PageView(
  onPageChanged: (value) {
    
    setState(() {
      pagetrack=value;
      onlastpage=(value==2);
    });
  },
          controller: controller,
          children: <Widget>[
             Intropage1(),
             Intropage2(),
             Intropage3()
          ],
        ),
        Container(
          alignment: Alignment(0, 0.75),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:[
              pagetrack==0? GestureDetector(
                onTap: ()async{
                  controller.animateToPage(3, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                     await analytics.logEvent(
                    name: "Screen3",
                    parameters: {
                      "ScreenIndex":controller.page,
                      "Screen_Page":3

                    }
                  );
                },
                child: Text("Skip"),
               ):
              onlastpage?
               GestureDetector(
                onTap: ()async{
                  controller.animateToPage(pagetrack-1, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                 await analytics.logEvent(
                    name: "Screen2",
                    parameters: {
                      "ScreenIndex":controller.page,
                      "Screen_Page":2

                    }
                 );
                },
                child: Text("Back"),
               ):
              GestureDetector(
                onTap: ()async{
                  controller.animateToPage(pagetrack-1, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                      await analytics.logEvent(
                    name: "Screen1",
                    parameters: {
                      "ScreenIndex":controller.page,
                      "Screen_Page":1

                    }
                 );
                },
                child: Text("back")),
               SmoothPageIndicator(controller: controller, count: 3),
               onlastpage?
               GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return Register();
                  }));
                  
                },
                child: Text("Get Started"),
               ):
                             GestureDetector(
                              onTap: (){
                  controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                },
                              child: Text("Next")),

            ]
            ))
        ],
      ),
    );
  }
}