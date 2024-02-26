import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:msd_project_food_diary/Data/DatabaseHelper.dart';
import 'package:msd_project_food_diary/Data/SharedPreferences/SharedPreferencesHelper.dart';
import 'package:msd_project_food_diary/Model/Image.dart';

import 'DisplayPicture.dart';
class TakePictureScreen extends StatefulWidget {
  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}
class _TakePictureScreenState extends State<TakePictureScreen> {
  List<CameraDescription>? cameras; // List to store available cameras
  CameraController? controller; // Controller for camera
  XFile? image; // To store the captured image
  late Databasehelper handler;
  String? Username="";
  @override
  void initState() {
    loadCamera();
    super.initState();
    handler=Databasehelper();
    handler.InitiDb();
    loadUsername();
  }
  loadUsername()async{
    Username=await SharedPreferenceHelper().getUsername();
    setState(() {
      
    });
  }
  loadCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller= CameraController(cameras![0], ResolutionPreset.max);
      // Cameras[0] is the first camera, you can change to other cameras if  available
      controller!.initialize().then((_) {
    if (!mounted) {
    return;
    }
    setState(() {});
    });
    } else {
    print("NO camera found");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){
  Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back, size: 20,color: Colors.black,)),
          backgroundColor: Colors.white,
        title: Text("Live Camera Preview"),
    ),
    body: Center(
    child: Container(
    child: Column(
    children: [
    Expanded(
    child: Container(
    child: controller == null
    ? Center(child: Text("Loading Camera..."))
        : !controller!.value.isInitialized
    ? Center(
    child: CircularProgressIndicator(),
    )
        : CameraPreview(controller!),
    ),
    ),
    ],
    ),
    ),
    ),
    floatingActionButton: Align(
    alignment: Alignment.bottomCenter,
    child: FloatingActionButton(
    onPressed: () async {
    try {
    if (controller != null) {
    // Check if the controller is not null
    if (controller!.value.isInitialized) {
    // Check if the controller is initialized
    image = await controller!.takePicture(); // Capture the 
    await handler.InsertImage(ImageModel(path: image!.path, username: Username!,));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DisplayPictureScreen(imagePath: image!.path),
      ),
    );
    setState(() {
      // Update UI
    });
    }
    }
    } catch (e) {
      print(e); // Print any error that occurs
    }
    },
      child: Icon(Icons.camera_alt),
    ),
    ),
    );
  }
}