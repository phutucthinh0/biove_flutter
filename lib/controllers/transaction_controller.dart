import 'package:biove/constants/transaction_status.dart';
import 'package:biove/models/transaction.dart';
import 'package:get/get.dart';

class TransactionController extends GetxController {
  var transactionStatus = (TransactionStatus.initialized).obs;
}