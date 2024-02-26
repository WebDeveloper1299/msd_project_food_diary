class ImageModel {
   int ?id;
   String? title;
   late String username;
  late String path;
  String? comments;

  ImageModel({this.id, required this.username, required this.path, this.comments='', this.title=''});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username':username,
      'path': path,
      'comments':comments,
      'title':title,
    };
  }

ImageModel.fromMap(Map<String, dynamic> map) {
    id=map['id'];
    username=map['username'];
    path=map['path'];
    comments=map['comments'];
    title=map['title'];
  }
    // This method returns a string representation of the Image

   @override
 String toString() {
 return ' ImageModel{'
 'id: $id, '
 'username: $username, '
 'path:$path,'
 'comments:$comments,'
 'title:$title';
}
}
