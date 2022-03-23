import 'package:biove/widgets/text_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'opacity_button.dart';

// ignore: use_key_in_widget_constructors
class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: TextUI("Trang thanh toán", fontSize: 20, color: Colors.white),
      ),
      backgroundColor: Color(0xfff7f7f7),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10,),
        child: Column(children: [
          Container(
            color: Colors.white,
            height: 100,
            child: Row(children: [
              SizedBox(
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  TextUI("Releasing", color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 20,margin: EdgeInsets.only(top: 20, left: 10) ),
                  TextUI("vui lòng thanh toán trong thời gian 15 phút !", color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 14,margin: EdgeInsets.only(left: 10, top: 5) )
                ],),
              ),
              Spacer(),
              TextUI("15:00", color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 24, margin: EdgeInsets.only(right: 20),)
            ],) ,),
          SizedBox(height: 20,),
          Container(
            color: Colors.white,
            height: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              TextUI("Giao dịch mua cây: Phượng Brazil !", color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18,margin: EdgeInsets.only( top: 5) ),
              TextUI("Đến số tài khoản: 0123456789123", color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 14,margin: EdgeInsets.only(top: 5) ),
              TextUI("Ngân hàng : ngân hàng á châu ACB, chi nhánh Đồng Nai", color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 14,margin: EdgeInsets.only(top: 5) ),
              TextUI("Người thụ hưởng: Cty TNHH Biove", color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 14,margin: EdgeInsets.only(top: 5) ),
              TextUI("Nội dung chuyển khoảng: 01234578512", color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 14,margin: EdgeInsets.only(top: 5) ),
              TextUI("Số tiền chuyển khoản: 100.000.000 đ", color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 14,margin: EdgeInsets.only(top: 5) ),
          ],),),
          SizedBox(height: 20,),
          Center(
            child: OpacityButton(
              onTap: (){
                Get.to(()=> PaymentScreen());
              },
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
                child: Center(child: TextUI('Đã chuyển tiền', color: Colors.white, fontWeight: FontWeight.bold,),),
              ),
            ),
          )

        ],),
      ),
    );
  }
}
