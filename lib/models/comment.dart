import 'package:biove/models/user.dart';

class Comment {
  User user;
  DateTime date;
  String body;

  Comment({required this.user, required this.date, required this.body});

  factory Comment.fromMap(dynamic data){
    return Comment(
        user: User(id: data['author_id'], name: data['author_name'], photoURL: data['author_photoURL']),
        date: DateTime.fromMillisecondsSinceEpoch(data['date']),
        body: data['body']
    );
  }
}