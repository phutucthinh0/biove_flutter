import 'package:biove/models/comment.dart';
import 'package:biove/models/user.dart';

import '../data/db.dart';

class Story {
  String id;
  User author;
  DateTime date;
  String body;
  String media;
  bool isAccountLike;
  List<User> like;
  List<Comment> comment;
  List<User> share;

  Story({required this.id, required this.author, required this.date, required this.body, required this.media, required this.like, required this.comment, required this.share, required this.isAccountLike});

  factory Story.fromMap(dynamic data){
    List<User> _uLike = [];
    List<Comment> _uComment = [];
    List<User> _uShare = [];
    bool _isAccountLike = false;
    for(dynamic element in data['like']){
      if(db.getAccountId()==element['user_id']){
        _isAccountLike = true;
      }
      _uLike.add(User(id: element['user_id'], name: element['name'], photoURL: element['photoURL']));
    }
    for(dynamic element in data['comment']){
      _uComment.add(Comment.fromMap(element));
    }

    return Story(
        id: data['_id'],
        author: User(id: data['author_id'], name: data['author_name'], photoURL: data['author_photoURL']),
        date: DateTime.fromMillisecondsSinceEpoch(data['date']),
        body: data['body'],
        media: data['media'],
        isAccountLike: _isAccountLike,
        like: _uLike,
        comment: _uComment,
        share: _uShare);
  }
}