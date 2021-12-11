import 'package:biove/data/db.dart';
import 'package:biove/widgets/text_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Payment extends StatefulWidget {
  final String price;

  const Payment({Key? key, required this.price}) : super(key: key);
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: TextUI("Thanh toán an toàn", fontSize: 20, color: Colors.white),
      ),
      backgroundColor: Color(0xfff7f7f7),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextUI('Phương thức thanh toán', fontWeight: FontWeight.bold, fontSize: 22,),
            SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
              Image.asset("assets/logo_momo.png", width: 60,),
              Image.asset("assets/logo_zalo.png", width: 60),
              Image.asset("assets/logo_vcb.jpg", width: 60),
            ]),
            Container(
              width: Get.width - 40,
              height: 500,
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
                  TextUI('Cây phượng'),
                ]),
                SizedBox(height: 10),
                Spacer(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  TextUI('Tổng tiền', color: Colors.green,),
                  TextUI(widget.price, fontWeight: FontWeight.bold, fontSize: 22,),
                ]),
              ]),
            ),
            Center(
              child: Container(
                width: Get.width - 80,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [Color(0xff294b6b), Color(0xff38a09d)],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(0.0, 1.0),
                    )
                ),
                child: Center(child: TextUI('XÁC NHẬN', color: Colors.white, fontWeight: FontWeight.bold,),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
