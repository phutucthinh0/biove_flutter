import 'package:biove/models/comment.dart';
import 'package:biove/models/user.dart';

class Story {
  String id;
  User author;
  DateTime date;
  String body;
  String media;
  List<User> like;
  List<Comment> comment;
  List<User> share;

  Story({required this.id, required this.author, required this.date, required this.body, required this.media, required this.like, required this.comment, required this.share});

  factory Story.fromMap(dynamic data){
    List<User> _uLike = [];
    List<Comment> _uComment = [];
    List<User> _uShare = [];
    for(dynamic element in data['like']){
      _uLike.add(User(id: element['_id'], name: element['name'], photoURL: element['photoURL']));
    }
    for(dynamic element in data['comment']){
      _uLike.add(User(id: element['_id'], name: element['name'], photoURL: element['photoURL']));
    }

    return Story(
        id: data['_id'],
        author: User(id: data['author_id'], name: data['author_name'], photoURL: data['author_photoURL']),
        date: DateTime.fromMillisecondsSinceEpoch(data['date']),
        body: data['body'],
        media: data['media'],
        like: _uLike,
        comment: _uComment,
        share: _uShare);
  }
}