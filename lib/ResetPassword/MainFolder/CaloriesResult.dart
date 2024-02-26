import 'package:flutter/material.dart';
import 'package:msd_project_food_diary/ResetPassword/MainFolder/CaloriesCalculator.dart';

class Calories extends StatefulWidget {
  final double bmr;
  final String activity;
  final String recommand;
  final String imagePath;

  const Calories({
    Key? key,
    required this.bmr,
    required this.activity,
    required this.recommand,
    required this.imagePath,
  }) : super(key: key);

  @override
  State<Calories> createState() => _CaloriesState();
}

class _CaloriesState extends State<Calories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CaloriesCalculate()),
            );
          },
          child: const Icon(
            Icons.arrow_back,
            size: 20,
            color: Color(0xFF042960),
          ),
        ),
        backgroundColor: const Color(0xFFECECEC),
      ),
      backgroundColor: const Color(0xFFECECEC),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildHeaderText(),
              _buildDescriptionText(),
              _buildBMRWidget(),
              _buildActivityLevelText(),
              
                 _buildActivityImage(),
                    _buildSuggestionText(),             

               _buildRecommendationCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        Text(
          "Results",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFF042960),
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }

  Widget _buildDescriptionText() {
    return Container(
      width: 300,
      height: 100,
      child: const Text(
        "The results reveal a number of daily calories estimations that can be used to determine how many calories to consume every day in order to maintain your weight",
        style: TextStyle(
          color: Color(0xFF6C6C6C),
        ),
      ),
    );
  }

  Widget _buildBMRWidget() {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFE5F0C5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.bmr.toString(),
            style: const TextStyle(
              color: Color(0xFF474747),
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            "Calories/day",
            style: TextStyle(color: Color(0xFF474747), fontSize: 25),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityLevelText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 40),
        Container(
          width: double.infinity,
          height: 50,
          child: const Text(
            "Watch how your daily calories requirements vary as your activity level fluctuates",
            style: TextStyle(color: Color(0xFF6C6C6C), fontSize: 15),
          ),
        ),
        const Text(
          "Suggestion",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildSuggestionText() {
    return Card(
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Text(widget.recommand.toString()),
      ),
    );
  }

  Widget _buildActivityImage() {
    return Container(
      width: double.infinity,
      height: 200,
      child: Image.asset(
        widget.imagePath,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildRecommendationCard() {
    return const SizedBox(height: 40);
  }
}
