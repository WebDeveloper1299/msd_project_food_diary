import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class Intropage2 extends StatefulWidget {
  const Intropage2({super.key});

  @override
  State<Intropage2> createState() => _Intropage2State();
}

class _Intropage2State extends State<Intropage2> with SingleTickerProviderStateMixin{
   late final AnimationController _controller;

  
  late PageController controller = PageController();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller=AnimationController(vsync: this);
 
    
  }
    @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          Text("Food Focus: Picture Perfect Nutrition",style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
          SizedBox(
            height: 23,
          ),
         Center(child: Padding(
          padding: EdgeInsets.only(top: 0),
           child: LottieBuilder.network("https://lottie.host/6a17b37f-3ed6-40b4-b306-d76cdcde2e02/7hElBzuxuC.json", width: 330, height: 330, animate: true,repeat: true, onLoaded: (p0) {
                  _controller.duration=p0.duration;
                  _controller.forward();
                }, ),
         )),
               SizedBox(
                height: 10,
              ),
                            Text("Say goodbye to guesswork and hello to \ninformed eating", textAlign: TextAlign.center,)

        ],
      ),
    );
  }
}