import 'package:biove/constants/transaction_status.dart';

class Transaction {
  String id;
  String author_name;
  String author_id;
  String author_photoURL;
  int amount;
  int debit;
  String description;
  DateTime date;
  TransactionStatus transactionStatus;

  Transaction({
    required this.id,
    required this.author_name,
    required this.author_id,
    required this.author_photoURL,
    required this.amount,
    this.debit = 0,
    required this.description,
    required this.date,
    required this.transactionStatus
  });
}