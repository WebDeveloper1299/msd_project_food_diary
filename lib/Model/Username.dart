class Username{
   int? id ;
  late String username;
  Username({required this.username});
Map<String,dynamic>ToMap(){
  return{
    "id":id,
    "username":username,
  };
}
  Username.fromMap(Map<String, dynamic> map) {
  id=map['id'];
 username = map['username'];
 }
  // This method returns a string representation of the  Username.
 @override
 String toString() {
 return 'Username{'
 'id: $id, '
 'username: $username, ';
}
}