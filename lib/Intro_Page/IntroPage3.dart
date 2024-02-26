import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class Intropage3 extends StatefulWidget {
  const Intropage3({super.key});

  @override
  State<Intropage3> createState() => _Intropage3State();
}

class _Intropage3State extends State<Intropage3> with SingleTickerProviderStateMixin{
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
          Text("Visualize Healthy Eating Made Easy",style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
          SizedBox(
            height: 25,
          ),
         Center(child: LottieBuilder.network("https://lottie.host/ee0dc6b1-ae6b-438f-8d1f-9789da7dfdc0/UYKwbS9X1n.json", width: 330, height: 300, animate: true,repeat: true, onLoaded: (p0) {
                _controller.duration=p0.duration;
                _controller.forward();
              }, )),
               SizedBox(
                height: 30,
              ),
                                          Text("Transform your smartphone into a powerful tool\n for better nutrition", textAlign: TextAlign.center,)

        ],
      ),
    );
  }
}