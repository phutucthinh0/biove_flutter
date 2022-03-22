class User {
  String id;
  String name;
  String photoURL;

  User({required this.id, required this.name, required this.photoURL});
  
  factory User.fromMap(dynamic data){
    return User(id: data['_id'], name: data['name'], photoURL: data['photoURL']);
  }
}