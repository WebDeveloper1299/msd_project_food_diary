class UserProfile{
 int?id;
  late String username;
  late double weight;
  late int height;
  late int age;
  UserProfile({required this.username, required this.weight, required this.height, required this.age, this.id});

    Map<String, dynamic> toMap() {
    return {
      'id':id,
      'username':username,
      'weight':weight,
      'height':height,
      'age':age 
     
    };
  }
UserProfile.fromMap(Map<String, dynamic> map) {
    id=map['id'];
    username=map['username'];
    height = map["height"];
    weight=map['weight'];
    age=map['age'];
    
  }
  // This method returns a string representation of the UserProfiling.
 @override
 String toString() {
 return 'UserProfile{'
 'id: $id, '
 'username: $username, '
 'height:$height,'
 'weight:$weight,'
 'age:$age';
}
  

    

}