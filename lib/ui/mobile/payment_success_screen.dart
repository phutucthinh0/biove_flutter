import 'package:biove/models/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../data/db.dart';
import '../../widgets/button_ui.dart';
import '../../widgets/text_ui.dart';

class PaymentSuccessScreen extends StatefulWidget {
  TransactionModel transactionModel;
  PaymentSuccessScreen(this.transactionModel);

  @override
  _PaymentSuccessScreenState createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: TextUI('GIAO DỊCH THÀNH CÔNG', color: Colors.white, fontWeight: FontWeight.bold,),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Center(
            child: Image.asset(
              "assets/check-circle.gif",
              width: 100,
              height: 100,
            ),
          ),
          TextUI('   Thông tin giao dịch'),
          Container(
            width: Get.width - 40,
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                TextUI('Họ và Tên', color: Colors.green,),
                TextUI(db.getAccountName()),
              ]),
              SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                TextUI('Email', color: Colors.green,),
                TextUI(db.getAccountEmail()),
              ]),
              SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                TextUI('Tên cây', color: Colors.green,),
                TextUI(widget.transactionModel.description),
              ]),
              SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                TextUI('Thời gian giao dịch', color: Colors.green,),
                TextUI(DateFormat('HH:mm, d/MM/y').format(widget.transactionModel.date)),
              ]),
              SizedBox(height: 10),
              SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                TextUI('Tổng tiền', color: Colors.green,),
                TextUI(widget.transactionModel.price, fontWeight: FontWeight.bold, fontSize: 22,),
              ]),
            ]),
          ),
          Spacer(),
          Center(
            child: ButtonUI(
              text: 'TRỞ VỀ TRANG CHỦ',
              textColor: Colors.white,
              fontWeight: FontWeight.bold,
              backgroundColor: Colors.green,
              onTap: ()=>Get.back(),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
