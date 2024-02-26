import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class Intropage1 extends StatefulWidget {
  const Intropage1({super.key});

  @override
  State<Intropage1> createState() => _Intropage1State();
}

class _Intropage1State extends State<Intropage1> with SingleTickerProviderStateMixin{
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
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Snap & Track: Your Personal Food Diary",style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
          SizedBox(
            height: 20,
          ),
         Center(child: LottieBuilder.network("https://lottie.host/f6bd4265-24cb-43f9-b6e4-89e91a4bfd4c/x2iiQ0W1Pj.json", width: 300, height:300, animate: true,repeat: true, onLoaded: (p0) {
                _controller.duration=p0.duration;
                _controller.forward();
              }, )),
              SizedBox(
                height: 30,
              ),
              Text("Capture every meal and snack with ease using our\n intuitive app", textAlign: TextAlign.center,)
        ],
      ),
    );
  }
}