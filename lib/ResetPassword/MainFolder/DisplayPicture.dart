import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:msd_project_food_diary/Data/DatabaseHelper.dart';
import 'package:msd_project_food_diary/Data/SharedPreferences/SharedPreferencesHelper.dart';
import 'package:msd_project_food_diary/Model/Image.dart';
import 'package:msd_project_food_diary/ResetPassword/MainFolder/CamaeraPreview.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  DisplayPictureScreen({required this.imagePath});

  @override
  _DisplayPictureScreenState createState() =>
      _DisplayPictureScreenState(imagePath: imagePath);
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  final String imagePath;
  late Widget displayedImage;
  late List<ImageModel> imageList = [];
    String newTitle = "";
                         String newComment = ''; 
  late Databasehelper handle;
  String? username = "";
  final formKey = GlobalKey<FormState>();
  final TextEditingController title = TextEditingController();
  
    final TextEditingController comments = TextEditingController();

  _DisplayPictureScreenState({required this.imagePath});

  @override
  void initState() {
    super.initState();
    handle = Databasehelper();
    handle.InitiDb();
    displayedImage = _displayImage(imagePath);
    _loadData();

  }

  Future<void> _loadData() async {
    username = await SharedPreferenceHelper().getUsername();
    imageList = await handle.RetrieveImage(username);
  print(imageList);

    setState(() {});
  }

  Widget _displayImage(String path) {
    File imageFile = File(path);
    Container emptyPath = Container(
      child: Column(
        children: [
          Text(
            'Try here',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Icon(Icons.camera_alt_outlined, size: 40, color: Colors.black),
        ],
      ),
    );
    if (imageFile.existsSync() || imageList.isEmpty) {
      return emptyPath;
    } else {
      return emptyPath;
    }
  }

  void _handleImagePressed(String path) {
    setState(() {
      displayedImage = _displayImage(path);
    });
  }

  Future<void> _pickImage(int index) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await handle.updateImage(ImageModel(
          path: pickedFile.path, id: imageList[index].id, username: username!, comments: imageList[0].comments, title: imageList[0].title));
          await FirebaseAnalytics.instance.logEvent(
            name: "Change Image",
            parameters: {
              "Image Id":index,
              "ImagePath":pickedFile.path
            }
          );
      setState(() {
        _loadData();

      });
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              child: Image.asset(
                "Image/camera_one.jpg",
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: Card(
                elevation: 10.0,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 100, right: 100, top: 20, bottom: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        displayedImage,
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TakePictureScreen(),
                              ),
                            );
                          },
                          child: Text('Take a Picture'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            imageList.isEmpty
                ? _emptyImage()
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Image taken",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
            Padding(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GridView.builder(
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 15.0,
                      ),
                      itemCount: imageList.length,
                      itemBuilder: (BuildContext context, int index) {
                        String newTitle = "";
                         String newComment = ''; 
                        String imagePath = imageList[index].path;
                       

                        return Column(
                          children: [
                            Card(
                              elevation: 10.0,
                              child: Container(
                                width: double.infinity,
                                child: Column(
                                  children: <Widget>[
                                    Stack(
                                      children: [
                                        Container(
                                          height: 150,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: FileImage(File(imagePath)),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Opacity(
                                          opacity: 0.4,
                                          child: Container(
                                            width: double.infinity,
                                            height: 150,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onLongPress: () async {
                                                await handle.removeByImageId(
                                                    imageList[index].id);
                                                setState(() {
                                                  _loadData();
                                                });
                                              },
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: Opacity(
                                                  opacity: 0.7,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(35),
                                                    child: Container(
                                                      width: 40,
                                                      height: 40,
                                                      child: Card(
                                                        child: Icon(
                                                          Icons.close,
                                                          size: 20,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            GestureDetector(
                                              onTap: () {
                                                _pickImage(index);
                                                setState(() {
                                                  _loadData();
                                                });
                                              },
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: Opacity(
                                                  opacity: 0.7,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(35),
                                                    child: Container(
                                                      width: 40,
                                                      height: 40,
                                                      child: Card(
                                                        child: Icon(
                                                          Icons.image,
                                                          size: 20,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "${imageList[index].title.toString().isEmpty ? "Add Title" : imageList[index].title.toString()}",
                                                style: TextStyle(
                                                  overflow: TextOverflow.clip,
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                          SizedBox(height: 20),
                                          Row(
                                            children: [
                                              FittedBox(
                                                fit: BoxFit.contain,
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.7,
                                                  child: Text(
                                                    " ${imageList[index].comments.toString().isEmpty ? "Add Comments" : imageList[index].comments.toString()}",
                                                    textWidthBasis:
                                                        TextWidthBasis.parent,
                                                    style: TextStyle(
                                                      overflow: TextOverflow.clip,
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Card(
                                                  child: GestureDetector(
                                                      onTap: () async {
                                                        comments.text= imageList.isEmpty?"":  imageList[index].comments!.toString();
                       title.text= imageList.isEmpty?"":  imageList[index].title!.toString();
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: Text('Add Entry'),
                                                              content: SingleChildScrollView(
                                                                child: Form(
                                                                  key: formKey,
                                                                  child: Column(
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            double.infinity,
                                                                        height: 200,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          image:
                                                                              DecorationImage(
                                                                            image:
                                                                                FileImage(File(imagePath)),
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),
                                                                      SingleChildScrollView(
                                                                        child:
                                                                            TextFormField(
                                                                              controller:title ,
                                                                          validator:
                                                                              (value) {
                                                                            if (value ==
                                                                                    "" ||
                                                                                value!
                                                                                    .isEmpty) {
                                                                              return "Title is required";
                                                                            }
                                                                            return null;
                                                                          },
                                                                          onChanged:
                                                                              (value) {
                                                                            newTitle =
                                                                                value;
                                                                          },
                                                                          textAlignVertical:
                                                                              TextAlignVertical.top,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            labelText:
                                                                                'Enter Title',
                                                                            border:
                                                                                OutlineInputBorder(),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),
                                                                      SingleChildScrollView(
                                                                        child:
                                                                            TextFormField(
                                                                              controller: comments,
                                                                          validator:
                                                                              (value) {
                                                                            if (value ==
                                                                                    "" ||
                                                                                value!
                                                                                    .isEmpty) {
                                                                              return "Comment is required";
                                                                            }
                                                                            return null;
                                                                          },
                                                                          onChanged:
                                                                              (value) {
                                                                            newComment =
                                                                                value;
                                                                          },
                                                                          maxLines:
                                                                              null,
                                                                          minLines:
                                                                              3,
                                                                          textAlignVertical:
                                                                              TextAlignVertical.top,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            labelText:
                                                                                'Enter your comment',
                                                                            border:
                                                                                OutlineInputBorder(),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    if (formKey.currentState!.validate()) {
                                                                        Navigator.pop(
                                                                        context);
                                                                     }
                                                                    imageList[index]
                                                                            .comments =
                                                                        newComment;
                                                                    imageList[index]
                                                                        .title = newTitle;
                                                                    await handle
                                                                        .updateImage(
                                                                            imageList[index]);
                                                                       await analytics.logEvent(
  name: "Saved_Entry",
  parameters: {
    "Title": title.text,
    "Comments": comments.text,
  }


                                                                          );
                                                                  
                                                                    setState(
                                                                        () {
                                                                      _loadData();
                                                                      print(imageList);
                                                                    });
                                                                  },
                                                                  child:
                                                                      Text('Save'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Icon(Icons.edit)),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        selectedItemColor: Colors.black,
        showSelectedLabels: true,
        currentIndex: 3,
        onTap: (value) {
          if (value == 0) {
            Navigator.pushNamed(context, "/");
          } else if (value == 1) {
            Navigator.pushNamed(context, "/BMICalculator");
          } else if (value == 2) {
            Navigator.pushNamed(context, "/CaloriesCalculator");
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 20, color: Colors.black),
            label: "Home",
          ),
       
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate, size: 20, color: Colors.black),
            label: "BMI",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood, size: 20, color: Colors.black),
            label: "Calories",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_food_beverage, size: 20, color: Colors.black),
            label: "Dairy",
          ),
        ],
      ),
    );
  }

  Widget _emptyImage() {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  child: Image.asset(
                    "Image/EmptyFoods.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Try taking some picture",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
