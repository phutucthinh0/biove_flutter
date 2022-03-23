import 'dart:async';

import 'package:biove/constants/transaction_status.dart';
import 'package:biove/data/firestore_database.dart';
import 'package:biove/models/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/transaction_controller.dart';
import '../../widgets/button_ui.dart';
import '../../widgets/opacity_button.dart';
import '../../widgets/text_ui.dart';

class BioveTransactionUpdateAdmin extends StatefulWidget {
  TransactionModel transactionModel;


  BioveTransactionUpdateAdmin(this.transactionModel);

  @override
  _BioveTransactionUpdateAdminState createState() => _BioveTransactionUpdateAdminState();
}

class _BioveTransactionUpdateAdminState extends State<BioveTransactionUpdateAdmin> {
  Timer? _timer;
  late int countDown;
  TextEditingController _priceController = TextEditingController();
  TransactionController transactionController = Get.put(TransactionController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firestore.registerStreamTransaction(widget.transactionModel);
    _priceController.text = widget.transactionModel.price.split(".")[0];
    countDown = 900-(DateTime.now().millisecondsSinceEpoch - widget.transactionModel.date.millisecondsSinceEpoch)~/1000;
    if(countDown<0)countDown=0;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if(countDown>0){
        setState(() {
          countDown--;
        });
      }else{
        _timer!.cancel();
      }
    });
  }
  void accuracyHandle(){
    String _price = _priceController.text.trim();
    if(_price.isEmpty)_price = "0";
    if (!_price.isNum)return;
    int _debit = int.parse(_price)*1000;
    if (_debit==widget.transactionModel.amount){
      showDialog(
          context: context,
          builder: (_)=>CupertinoAlertDialog(
            title: TextUI('Đã nhận đủ', fontWeight: FontWeight.bold, color: Colors.red, fontSize: 20,),
            content: TextUI('Đã nhận ${widget.transactionModel.price} từ giao dịch ${widget.transactionModel.id}', fontSize: 14,),
            actions: [
              ButtonUI(
                text: 'TRỞ LẠI',
                textAlign: TextAlign.center,
                textColor: Colors.blue,
                onTap: ()=>Get.back(),
              ),
              ButtonUI(
                text: 'XÁC NHẬN',
                textAlign: TextAlign.center,
                textColor: Colors.blue,
                onTap: (){
                  Get.back();
                  widget.transactionModel.debit = _debit;
                  widget.transactionModel.transactionStatus = TransactionStatus.successful;
                  Firestore.updateTransaction(widget.transactionModel);
                },
              )
            ],
          )
      );
    }
    if (_debit > widget.transactionModel.amount){
      showDialog(
          context: context,
          builder: (_)=>CupertinoAlertDialog(
            title: TextUI('LỖI: NHẬN DƯ ${_debit-widget.transactionModel.amount} VNĐ', fontWeight: FontWeight.bold, color: Colors.red, fontSize: 20,),
            content: TextUI('Hệ thống nhận nhiều tiền hơn\nKiểm tra kĩ tài khoản ngân hàng\nĐã nhận ${_debit} VNĐ từ giao dịch ${widget.transactionModel.id}', fontSize: 14,),
            actions: [
              ButtonUI(
                text: 'TRỞ LẠI',
                textAlign: TextAlign.center,
                textColor: Colors.blue,
                onTap: ()=>Get.back(),
              ),
              ButtonUI(
                text: 'XÁC NHẬN',
                textAlign: TextAlign.center,
                textColor: Colors.blue,
                onTap: (){
                  Get.back();
                  widget.transactionModel.debit = _debit;
                  widget.transactionModel.transactionStatus = TransactionStatus.wrong;
                  Firestore.updateTransaction(widget.transactionModel);
                },
              )
            ],
          )
      );
    }
    if (_debit < widget.transactionModel.amount && _debit != 0){
      showDialog(
          context: context,
          builder: (_)=>CupertinoAlertDialog(
            title: TextUI('LỖI: NHẬN THIẾU ${widget.transactionModel.amount-_debit} VNĐ', fontWeight: FontWeight.bold, color: Colors.red, fontSize: 20,),
            content: TextUI('Hệ thống nhận KHÔNG ĐỦ tiền\nKiểm tra kĩ tài khoản ngân hàng\nĐã nhận ${_debit} VNĐ từ giao dịch ${widget.transactionModel.id}', fontSize: 14,),
            actions: [
              ButtonUI(
                text: 'TRỞ LẠI',
                textAlign: TextAlign.center,
                textColor: Colors.blue,
                onTap: ()=>Get.back(),
              ),
              ButtonUI(
                text: 'XÁC NHẬN',
                textAlign: TextAlign.center,
                textColor: Colors.blue,
                onTap: (){
                  Get.back();
                  widget.transactionModel.debit = _debit;
                  widget.transactionModel.transactionStatus = TransactionStatus.wrong;
                  Firestore.updateTransaction(widget.transactionModel);
                },
              )
            ],
          )
      );
    }
    if(_debit == 0) refuseTransaction();
  }
  void refuseTransaction(){
    showDialog(
        context: context,
        builder: (_)=>CupertinoAlertDialog(
          title: TextUI('TỪ CHỐI GIAO DỊCH', fontWeight: FontWeight.bold, color: Colors.red, fontSize: 20,),
          content: TextUI('Đã xác thực\nKHÔNG nhận được tiền từ giao dịch ${widget.transactionModel.id}', fontSize: 14,),
          actions: [
            ButtonUI(
              text: 'TRỞ LẠI',
              textAlign: TextAlign.center,
              textColor: Colors.blue,
              onTap: ()=>Get.back(),
            ),
            ButtonUI(
              text: 'XÁC NHẬN',
              textAlign: TextAlign.center,
              textColor: Colors.blue,
              onTap: (){
                Get.back();
                widget.transactionModel.debit = 0;
                widget.transactionModel.transactionStatus = TransactionStatus.refuse;
                Firestore.updateTransaction(widget.transactionModel);
              },
            )
          ],
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff121212),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Xác thực giao dịch'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: Get.height - 80,
          child: Column(
            children: [
              Container(
                color: Colors.transparent,
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextUI("${widget.transactionModel.id}", color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, margin: EdgeInsets.only(top: 20, left: 10)),
                          TextUI("Vui lòng kiểm tra kĩ thông tin trước khi xác nhận", color: Color(0xffb00020), fontWeight: FontWeight.bold, fontSize: 16, margin: EdgeInsets.only(left: 10, top: 5))
                        ],
                      ),
                    ),
                    Spacer(),
                    Center(
                      child: TextUI(
                        "${countDown ~/ 60}:${countDown % 60}",
                        color: Colors.yellowAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(width: 10)
                  ],
                ),
              ),
              SizedBox(height: 10),
              TextUI(
                widget.transactionModel.description,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              Container(
                width: Get.width - 10,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    TextUI(
                      'Mã giao dịch',
                      color: Colors.green,
                      fontSize: 16,
                    ),
                    Spacer(),
                    TextUI(
                      widget.transactionModel.id,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffb00020),
                      fontSize: 16,
                    ),
                  ]),
                  SizedBox(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    TextUI(
                      'User id',
                      color: Colors.green,
                      fontSize: 16,
                    ),
                    Spacer(),
                    TextUI(
                      widget.transactionModel.author_id,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ]),
                  SizedBox(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    TextUI(
                      'Họ và Tên',
                      color: Colors.green,
                      fontSize: 16,
                    ),
                    Spacer(),
                    TextUI(
                      widget.transactionModel.author_name,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ]),
                  SizedBox(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    TextUI(
                      'Email',
                      color: Colors.green,
                      fontSize: 16,
                    ),
                    Spacer(),
                    TextUI(
                      widget.transactionModel.author_email,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ]),
                  SizedBox(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    TextUI(
                      'Giá tiền',
                      color: Colors.green,
                      fontSize: 16,
                    ),
                    Spacer(),
                    TextUI(
                      widget.transactionModel.price,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffb00020),
                      fontSize: 16,
                    ),
                  ]),
                  Obx(() => (TransactionUtils.isBreakPoint(transactionStatus: transactionController.transactionStatus.value))
                      ? Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            TextUI(
                              'Số tiền đã nhận',
                              color: Colors.green,
                              fontSize: 16,
                            ),
                            Spacer(),
                            TextUI(
                              '${widget.transactionModel.debit} VNĐ',
                              fontWeight: FontWeight.bold,
                              color: Color(0xffb00020),
                              fontSize: 16,
                            ),
                          ]),
                        )
                      : Container()
                  ),

                  SizedBox(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    TextUI(
                      'Trạng thái giao dịch',
                      color: Colors.green,
                      fontSize: 16,
                    ),
                    Spacer(),
                    Obx(() => Container(
                        width: Get.width / 2,
                        child: TextUI(
                          getStringTransactionStatus(transactionController.transactionStatus.value),
                          textAlign: TextAlign.end,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(height: 20),
                ],),
              ),
              Container(width: Get.width,height: 2,color: Colors.white),
              SizedBox(height: 10),
              Obx(()=>(TransactionUtils.isBreakPoint(transactionStatus: transactionController.transactionStatus.value))
                  ? Container()
                  : Expanded(child: Column(children: _buildListAccuracy()))
              ),
              // TextUI("Hãy nhập số tiền bạn nhận được", color: Colors.white),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //       width: 50,
              //       child: TextFormField(
              //         controller: _priceController,
              //         keyboardType: TextInputType.number,
              //         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              //         textAlign: TextAlign.end,
              //       ),
              //     ),
              //     TextUI('.000 VNĐ', color: Colors.white, fontWeight: FontWeight.bold,)
              //   ],
              // ),
              // Spacer(),
              // Center(
              //   child: OpacityButton(
              //     onTap: () => accuracyHandle(),
              //     child: Container(
              //       width: Get.width - 80,
              //       height: 55,
              //       decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(10),
              //           color: Color(0xffffab00),
              //       ),
              //       child: Center(
              //         child: TextUI(
              //           'XÁC THỰC GIAO DỊCH',
              //           color: Colors.white,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 10),
              // ButtonUI(
              //   text: 'Giao dịch thất bại',
              //   textColor: Colors.red,
              //   onTap: () =>refuseTransaction(),
              // ),
              SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
  List<Widget> _buildListAccuracy(){
    return [TextUI("Hãy nhập số tiền bạn nhận được", color: Colors.white),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            child: TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.end,
            ),
          ),
          TextUI('.000 VNĐ', color: Colors.white, fontWeight: FontWeight.bold,)
        ],
      ),
      Spacer(),
      Center(
        child: OpacityButton(
          onTap: () => accuracyHandle(),
          child: Container(
            width: Get.width - 80,
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xffffab00),
            ),
            child: Center(
              child: TextUI(
                'XÁC THỰC GIAO DỊCH',
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      SizedBox(height: 10),
      ButtonUI(
        text: 'Giao dịch thất bại',
        textColor: Colors.red,
        onTap: () =>refuseTransaction(),
      )];
  }
  String getStringTransactionStatus(TransactionStatus transactionStatus){
    switch (transactionStatus){
      case TransactionStatus.initialized: return "Đã khởi tạo";
      case TransactionStatus.announced: return "Người dùng thông báo đã chuyển tiền";
      case TransactionStatus.successful: return "Thành công";
      case TransactionStatus.cancel: return "Giao dịch bị huỷ bởi người dùng";
      case TransactionStatus.timeout: return "Giao dịch bị huỷ do hết thời gian";
      case TransactionStatus.wrong: return "Người dùng chuyển sai số tiền";
      case TransactionStatus.refuse: return "Giao dịch thất bại";
      case TransactionStatus.error: return "Người dùng thông báo đã chuyển tiền nhưng hệ thống chưa nhận được";
      default: return "";
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Firestore.removeStreamTransaction();
    _timer!.cancel();
  }
}
