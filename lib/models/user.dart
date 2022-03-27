class User {
  String id;
  String name;
  String photoURL;

  User({required this.id, required this.name, required this.photoURL});
  
  factory User.fromMap(dynamic data){
    return User(id: data['user_id'], name: data['name'], photoURL: data['photoURL']);
  }
  toMap() => {
    'user_id':id,
    'name':name,
    'photoURL':photoURL
  };
}