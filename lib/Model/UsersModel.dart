class Users{

 int? id;
 late String username;

 late String password;

 late String cfmpassword;
 
Users({required this.username, required this.password});

 Map<String,dynamic>toMap(){
  return {
    "Username":username,
    "Password":password,
  };
 }
Users.fromMap(Map<String, dynamic> map) {
  id=map['id'];
 username = map['Username'];
 password=map['Password'];
 }
   // This method returns a string representation of the registrant.
 @override
 String toString() {
 return 'Users{'
 'id: $id, '
 'Username: $username, '
 'Password: $password,';
}

}