class ProfileImageModel {
   int ?id;
   late String username;
  late String path;

ProfileImageModel({this.id, required this.username, required this.path,});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username':username,
      'path': path,
    };
  }

ProfileImageModel.fromMap(Map<String, dynamic> map) {
    id=map['id'];
    username=map['username'];
    path=map['path'];
  }
    // This method returns a string representation of the Image

   @override
 String toString() {
 return ' ProfileImageModel{'
 'id: $id, '
 'username: $username, '
 'path:$path,';
}
}
