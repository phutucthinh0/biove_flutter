import 'dart:async';

import 'package:biove/constants/transaction_status.dart';
import 'package:biove/controllers/transaction_controller.dart';
import 'package:biove/data/firestore_database.dart';
import 'package:biove/helpers/dialog.dart';
import 'package:biove/models/transaction.dart';
import 'package:biove/models/type_of_tree.dart';
import 'package:biove/ui/mobile/payment_success_screen.dart';
import 'package:biove/widgets/button_ui.dart';
import 'package:biove/widgets/text_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../widgets/opacity_button.dart';

// ignore: use_key_in_widget_constructors
class PaymentScreen extends StatefulWidget {
  TransactionModel transactionModel;

  PaymentScreen(this.transactionModel);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Timer? _timer;
  int countDown = 900;
  bool canTapAnnounced = false;
  TransactionController transactionController = Get.put(TransactionController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firestore.registerStreamTransaction(widget.transactionModel);
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if(countDown==0){
        _timer!.cancel();
        _onTimeout();
        return;
      }
      if(countDown == 600){
        setState(() {
          canTapAnnounced = true;
        });
      }
      if(countDown == 540 && transactionController.transactionStatus.value == TransactionStatus.initialized){
        showDialog(
            context: context,
            builder: (_)=>CupertinoAlertDialog(
              title: TextUI('Nếu bạn đã chuyển khoản\nHãy thông báo chuyển tiền cho chúng tôi', fontWeight: FontWeight.bold),
            )
        );
      }
      if(countDown == 300 && transactionController.transactionStatus.value == TransactionStatus.initialized){
        showDialog(
            context: context,
            builder: (_)=>CupertinoAlertDialog(
              title: TextUI('Nếu bạn đã chuyển khoản\nHãy nhấn ĐÃ CHUYỂN TIỀN', fontWeight: FontWeight.bold),
            )
        );
      }
      if(countDown == 120 && transactionController.transactionStatus.value == TransactionStatus.initialized){
        showDialog(
            context: context,
            builder: (_)=>CupertinoAlertDialog(
              title: TextUI('Nếu bạn đã chuyển khoản\nHãy nhấn ĐÃ CHUYỂN TIỀN', fontWeight: FontWeight.bold),
            )
        );
      }
      setState(() {
        countDown--;
      });
    });
    transactionController.transactionStatus.listen((p0) {
      if(p0==TransactionStatus.successful){
        widget.transactionModel.transactionStatus = TransactionStatus.successful;
        Get.off(()=>PaymentSuccessScreen(widget.transactionModel));
      }
    });
  }
  _onTimeout(){
    if(transactionController.transactionStatus.value == TransactionStatus.announced){
      widget.transactionModel.transactionStatus = TransactionStatus.error;
    }else{
      widget.transactionModel.transactionStatus = TransactionStatus.timeout;
    }
    Firestore.updateTransaction(widget.transactionModel);
  }
  _onAnnounced(){
    if(canTapAnnounced){
      if(TransactionUtils.isBreakPoint(transactionStatus: transactionController.transactionStatus.value)){

      }else{
        showDialog(
            context: context,
            builder: (_)=>CupertinoAlertDialog(
              title: TextUI('Thông báo đã chuyển tiền', fontWeight: FontWeight.bold, color: Colors.red, fontSize: 20,),
              content: TextUI('Tôi đã chuyển ${widget.transactionModel.price} vào đúng thông tin chuyển khoản, và hệ thống chưa xác nhận giao dịch', fontSize: 14,),
              actions: [
                ButtonUI(
                  text: 'TRỞ LẠI',
                  textAlign: TextAlign.center,
                  textColor: Colors.blue,
                  onTap: ()=>Get.back(),
                ),
                ButtonUI(
                  text: 'ĐÚNG',
                  textAlign: TextAlign.center,
                  textColor: Colors.blue,
                  onTap: (){
                    Get.back();
                    widget.transactionModel.transactionStatus = TransactionStatus.announced;
                    Firestore.updateTransaction(widget.transactionModel);
                  },
                )
              ],
            )
        );
      }
    }else{
      showDialog(
        context: context,
        builder: (_)=>CupertinoAlertDialog(
          title: TextUI('Giao dịch sẽ tự động xác nhận', fontWeight: FontWeight.bold,),
          content: TextUI('Trong vòng 5 phút, nếu hệ thống không tự động xác nhận hãy thử lại'),
        )
      );
    }
  }
  void _onCancel(){
    showDialog(
        context: context,
        builder: (_)=>CupertinoAlertDialog(
          title: TextUI('Huỷ giao dịch', fontWeight: FontWeight.bold, color: Colors.red, fontSize: 22,),
          content: TextUI('Bạn có chắc chắn muốn huỷ giao dịch?'),
          actions: [
            ButtonUI(
              text: 'NO',
              textAlign: TextAlign.center,
              textColor: Colors.blue,
              onTap: ()=>Get.back(),
            ),
            ButtonUI(
              text: 'YES',
              textAlign: TextAlign.center,
              textColor: Colors.blue,
              onTap: (){
                Get.back();
                _cancelTransaction();
              },
            )
          ],
        )
    );
  }
  void _cancelTransaction(){
    if(TransactionUtils.isBreakPoint(transactionStatus: transactionController.transactionStatus.value)){
      showDialog(
          context: context,
          builder: (_)=>CupertinoAlertDialog(
            title: TextUI('Huỷ giao dịch không thành công', fontWeight: FontWeight.bold),
            content: TextUI('Hệ thống đang xử lý giao dịch của bạn\nVui lòng thử lại'),
          )
      );
    }else{
      widget.transactionModel.transactionStatus = TransactionStatus.cancel;
      Firestore.updateTransaction(widget.transactionModel);
      Get.back();
      showDialog(
          context: context,
          builder: (_)=>CupertinoAlertDialog(
            title: TextUI('Đã huỷ giao dịch ${widget.transactionModel.description}', fontWeight: FontWeight.bold),
          )
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.green,
      //   centerTitle: true,
      //   title: TextUI("Trang thanh toán", fontSize: 20, color: Colors.white),
      // ),
      backgroundColor: Color(0xff121212),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                        TextUI("Giao dịch", color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, margin: EdgeInsets.only(top: 20, left: 10)),
                        TextUI("Vui lòng thanh toán trong thời gian\n15 phút", color: Color(0xffb00020), fontWeight: FontWeight.bold, fontSize: 16, margin: EdgeInsets.only(left: 10, top: 5))
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
            SizedBox(height: 10),
            TextUI(
              'Mã giao dịch: ${widget.transactionModel.id}',
              fontSize: 10,
              fontWeight: FontWeight.w100,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Container(
              width: Get.width - 10,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(children: [
                OpacityButton(
                  onTap: () {
                    Get.snackbar('Đã sao chép',"TẠ NGUYỄN ANH THƯ");
                    Clipboard.setData(ClipboardData(text: "TẠ NGUYỄN ANH THƯ"));
                  },
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    TextUI(
                      'Tên người thụ hưởng',
                      color: Colors.green,
                      fontSize: 16,
                    ),
                    Spacer(),
                    TextUI(
                      'TẠ NGUYỄN ANH THƯ',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ]),
                ),
                SizedBox(height: 20),
                OpacityButton(
                  onTap: (){
                    Get.snackbar('Đã sao chép',"67010001283428");
                    Clipboard.setData(ClipboardData(text: "67010001283428"));
                  },
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    TextUI(
                      'Tài khoản thụ hưởng',
                      color: Colors.green,
                      fontSize: 16,
                    ),
                    TextUI(
                      '67010001283428',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ]),
                ),
                SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  TextUI(
                    'Ngân hàng thụ hưởng',
                    color: Colors.green,
                    fontSize: 16,
                  ),
                  TextUI(
                    'BIDV',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ]),
                SizedBox(height: 20),
                OpacityButton(
                  onTap: (){
                    Get.snackbar('Đã sao chép',widget.transactionModel.id);
                    Clipboard.setData(ClipboardData(text: widget.transactionModel.id));
                  },
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    TextUI(
                      'Nội dung chuyển khoản',
                      color: Colors.green,
                      fontSize: 16,
                    ),
                    TextUI(
                      '${widget.transactionModel.id}',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ]),
                ),
                SizedBox(height: 20),
                OpacityButton(
                  onTap: (){
                    Get.snackbar('Đã sao chép',widget.transactionModel.amount.toString());
                    Clipboard.setData(ClipboardData(text: widget.transactionModel.amount.toString()));
                  },
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    TextUI(
                      'Số tiền chuyển',
                      color: Colors.green,
                      fontSize: 16,
                    ),
                    TextUI(
                      widget.transactionModel.price,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ]),
                ),
              ]),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: Get.width-20,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 2, color: Colors.yellowAccent)
              ),
              child: Obx(
                ()=> TextUI(
                  buildCaution(transactionController.transactionStatus.value),
                  color: Colors.yellow,
                  fontSize: 13,
                ),
              ),
            ),
            Spacer(),
            Obx(
              () => (transactionController.transactionStatus.value != TransactionStatus.initialized)
                  ? Container()
                  : Column(
                      children: [
                        Center(
                          child: OpacityButton(
                            onTap: () => _onAnnounced(),
                            child: Container(
                              width: Get.width - 80,
                              height: 55,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: canTapAnnounced ? Color(0xffffab00) : Colors.grey),
                              child: Center(
                                child: TextUI(
                                  'ĐÃ CHUYỂN TIỀN',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        ButtonUI(
                          text: 'Huỷ giao dịch',
                          textColor: Colors.red,
                          onTap: () => _onCancel(),
                        ),
                      ],
                    ),
            ),
            Obx(() => (transactionController.transactionStatus.value == TransactionStatus.timeout)
                ? ButtonUI(
                    text: 'HẾT THỜI GIAN, QUAY LẠI',
                    textColor: Colors.white,
                    fontWeight: FontWeight.bold,
                    backgroundColor: Colors.red,
                    onTap: ()=>Get.back(),
                  )
                : Container()),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  String buildCaution(TransactionStatus status) {
    if (status == TransactionStatus.initialized) {
      return '- Vui lòng chuyển khoản trong thời gian quy định\n\n'
          '- Nội dung chuyển khoản là MÃ GIAO DỊCH\n\n'
          '- Nội dung chuyển khoản KHÔNG được chứa bất kì thông tin nào khác\n\n'
          '- Sử dụng lệnh chuyển nhanh 24/7 qua số tài khoản\n\n'
          '- Sau khi chuyển tiền hệ thống sẽ tự động xác nhận, trong trường hợp hệ thống không tự xác nhận hãy nhấn ĐÃ CHUYỂN TIỀN\n\n'
          '- Có thể mất từ 5-10 phút để hệ thống xác nhận chuyển khoản\n\n'
          '- Để sao chép nội dung hãy nhấn vào chúng'
      ;
    }
    if (status == TransactionStatus.announced) {
      return '- Bạn đã thông báo chuyển tiền\n\n'
          '- Hệ thống đang xửa lý giao dịch của bạn\n\n'
          '- Có thể mất từ 5-10 phút để hệ thống xác nhận chuyển khoản\n\n'
          '- Trong trường hợp hết thời gian, nhưng hệ thống vẫn chưa xác nhận, giao dịch của bạn sẽ được xử lý từ 1-2 ngày làm việc, tuỳ vào hệ thống ngân hàng của bạn';
    }
    if (status == TransactionStatus.error) {
      return 'HẾT THỜI GIAN\n\n'
          '- Giao dịch của bạn sẽ được xử lý từ 1-2 ngày làm việc, tuỳ vào hệ thống ngân hàng của bạn\n\n'
          '- Chúng tôi sẽ thông báo cho bạn ngay khi có kết quả\n\n'
          '- Hãy yên tâm chúng tôi sẽ hoàn lại tiền cho nếu có lỗi xảy ra\n\n'
          '- Hãy chụp màn hình lại để tiện cho theo dõi sau này\n\n'
          '- Cám ơn bạn đã ủng hộ cho dự án BIOVE';
    }
    if (status == TransactionStatus.timeout) {
      return 'HẾT THỜI GIAN - GIAO DỊCH BỊ HUỶ\n\n'
          '- Bạn chưa thông báo chuyển tiền cho hệ thống nên giao dịch bị huỷ\n\n'
          '- Hãy yên tâm chúng tôi sẽ hoàn lại tiền cho nếu có lỗi xảy ra\n\n'
          '- Hãy chụp màn hình lại để tiện cho theo dõi sau này\n\n'
          '- Cám ơn bạn đã ủng hộ cho dự án BIOVE';
    }
    if (status == TransactionStatus.successful) {
      return 'GIAO DỊCH THÀNH CÔNG\n\n'
          '- Cám ơn bạn đã ủng hộ cho dự án BIOVE';
    }
    return '';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer!.cancel();
    Firestore.removeStreamTransaction();
  }
}
