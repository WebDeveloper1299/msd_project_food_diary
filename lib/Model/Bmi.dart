class BMI{
  int?id;
  late String username;
  late double bmi;
  BMI({ required this.username, required this.bmi});

    Map<String, dynamic> toMap() {
    return {
      'id':id,
      'username':username,
       'bmi':bmi,
     
    };
  }
BMI.fromMap(Map<String, dynamic> map) {
    id=map['id'];
    username=map['username'];
   bmi=map['bmi'];
  }

//String Representation of BMI Model
  
 @override
 String toString() {
 return 'BMI{'
 'id: $id'
 'username: $username'
 'bmi:$bmi';
}
    

}