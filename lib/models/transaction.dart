import 'package:biove/constants/transaction_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  String id;
  String author_name;
  String author_id;
  String author_photoURL;
  String author_email;
  String typeOfTree_id;
  String price;
  int amount;
  int debit;
  String description;
  DateTime date;
  TransactionStatus transactionStatus;

  TransactionModel({
    required this.id,
    required this.author_name,
    required this.author_id,
    required this.author_photoURL,
    required this.author_email,
    required this.typeOfTree_id,
    required this.price,
    required this.amount,
    required this.debit,
    required this.description,
    required this.date,
    required this.transactionStatus
  });
  factory TransactionModel.fromDocument(DocumentSnapshot _docSnapShot){
    return TransactionModel(
        id: _docSnapShot.id,
        author_name: _docSnapShot.get('author_name'),
        author_id: _docSnapShot.get('author_id'),
        author_photoURL: _docSnapShot.get('author_photoURL'),
        author_email: _docSnapShot.get('author_email'),
        typeOfTree_id: _docSnapShot.get('typeOfTree_id'),
        price: _docSnapShot.get('price'),
        amount: _docSnapShot.get('amount'),
        debit: _docSnapShot.get('debit'),
        description: _docSnapShot.get('description'),
        date: DateTime.fromMillisecondsSinceEpoch(_docSnapShot.get('date')),
        transactionStatus: TransactionUtils.toEnum(_docSnapShot.get('transactionStatus')));
  }
  factory TransactionModel.fromMap(dynamic _data){
    return TransactionModel(
        id: _data['id'],
        author_name: _data['author_name'],
        author_id: _data['author_id'],
        author_photoURL: _data['author_photoURL'],
        author_email: _data['author_email'],
        typeOfTree_id: _data['typeOfTree_id'],
        price: _data['price'],
        amount: _data['amount'],
        debit: _data['debit'],
        description: _data['description'],
        date: _data['date'],
        transactionStatus: TransactionUtils.toEnum(_data['transactionStatus']));
  }
  toMap(){
    return {
      'id': id,
      'author_name': author_name,
      'author_id': author_id,
      'author_photoURL': author_photoURL,
      'author_email': author_email,
      'amount': amount,
      'debit': debit,
      'description': description,
      'date': date.millisecondsSinceEpoch,
      'transactionStatus': TransactionUtils.toCode(transactionStatus)
    };
  }
  toDocument(){
    return {
      'author_name': author_name,
      'author_id': author_id,
      'author_photoURL': author_photoURL,
      'author_email': author_email,
      'amount': amount,
      'debit': debit,
      'description': description,
      'date': date.millisecondsSinceEpoch,
      'transactionStatus': TransactionUtils.toCode(transactionStatus)
    };
  }
}