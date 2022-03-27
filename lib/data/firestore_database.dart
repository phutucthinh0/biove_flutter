import 'package:biove/constants/transaction_status.dart';
import 'package:biove/controllers/transaction_controller.dart';
import 'package:biove/models/story.dart';
import 'package:biove/models/transaction.dart';
import 'package:biove/models/type_of_tree.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'db.dart';

class Firestore {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static Stream<DocumentSnapshot>? _streamTransaction;
  static Stream<DocumentSnapshot>? _streamStory;
  static void initialize(){

  }
  static Future<TransactionModel> addTransaction(TypeOfTree typeOfTree)async{
    final _docRef = await firestore.collection("bank").add({
      'author_id': db.getAccountId(),
      'author_name': db.getAccountName(),
      'author_photoURL': db.getAccountPicture(),
      'author_email': db.getAccountEmail(),
      'typeOfTree_id': typeOfTree.id,
      'price': typeOfTree.price,
      'amount': typeOfTree.amount,
      'debit': 0,
      'description': '${typeOfTree.name}',
      'date': DateTime.now().millisecondsSinceEpoch,
      'transactionStatus': TransactionUtils.toCode(TransactionStatus.initialized)
    });
    final _docSnap = await _docRef.get();
    return TransactionModel.fromDocument(_docSnap);
  }
  static Future<void> updateTransaction(TransactionModel transactionModel)async{
    await firestore.collection("bank").doc(transactionModel.id).update(transactionModel.toDocument());
  }
  static void registerStreamTransaction(TransactionModel transactionModel){
    TransactionController _transactionController = Get.find();
    _streamTransaction = firestore.collection("bank").doc(transactionModel.id).snapshots();
    _streamTransaction!.listen((DocumentSnapshot snapshot) {
      int code = snapshot.get('transactionStatus');
      _transactionController.transactionStatus(TransactionUtils.toEnum(code));
    });
  }
  static void removeStreamTransaction(){
    _streamTransaction = null;
  }
  static Future<List<TransactionModel>> getTransactionHolding()async{
    List<TransactionModel> _list = [];
    QuerySnapshot result = await firestore.collection("bank").where('transactionStatus', whereIn: [100,101,401,500]).get();
    result.docs.forEach((element) {
      _list.add(TransactionModel.fromDocument(element));
    });
    return _list;
  }
  static Future<List<TransactionModel>> getTransactionSuccessful()async{
    List<TransactionModel> _list = [];
    QuerySnapshot result = await firestore.collection("bank").where('transactionStatus', whereIn: [200,402]).get();
    result.docs.forEach((element) {
      _list.add(TransactionModel.fromDocument(element));
    });
    return _list;
  }
  static Future<List<TransactionModel>> getTransactionFailed()async{
    List<TransactionModel> _list = [];
    QuerySnapshot result = await firestore.collection("bank").where('transactionStatus', whereIn: [400,403]).get();
    result.docs.forEach((element) {
      _list.add(TransactionModel.fromDocument(element));
    });
    return _list;
  }
  static Future<void> likeStory(Story story) async {
    await firestore.collection("story").doc(story.id).set({'like':[story.author.toMap()]}, SetOptions(merge: true));
  }
}