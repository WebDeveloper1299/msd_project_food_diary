class CaloriesData{
  int? id;
  late String? username;
  late double? bmr;
CaloriesData({required this.username , required this.bmr, });
 
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username':username,
      'bmr':bmr,
    };
  }
CaloriesData.fromMap(Map<String, dynamic> map) {
    id=map['id'];
    username=map['username'];
    bmr=map['bmr'];
  }
    // This method returns a string representation of the Calories
 
   @override
 String toString() {
 return 'Calories{'
 'id: $id, '
 'username: $username, '
 'bmr:$bmr';
}

}


