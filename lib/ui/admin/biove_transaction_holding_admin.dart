import 'dart:async';

import 'package:biove/data/firestore_database.dart';
import 'package:biove/models/transaction.dart';
import 'package:biove/ui/admin/biove_tranaction_update_admin.dart';
import 'package:biove/widgets/opacity_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/text_ui.dart';

class BioveTransactionHoldingAdmin extends StatefulWidget {

  @override
  _BioveTransactionHoldingAdminState createState() => _BioveTransactionHoldingAdminState();
}

class _BioveTransactionHoldingAdminState extends State<BioveTransactionHoldingAdmin> {
  late List<TransactionModel> _listTransactionModel;
  List<int> _listTimer = [];
  bool _initialize = true;
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initStateAsync();
  }
  initStateAsync()async{
    _listTimer = [];
    _listTransactionModel = [];
    if(timer!=null)timer!.cancel();
    _listTransactionModel = await Firestore.getTransactionHolding();
    for(int i=0; i< _listTransactionModel.length;i++){
      _listTimer.add(900-(DateTime.now().millisecondsSinceEpoch - _listTransactionModel[i].date.millisecondsSinceEpoch)~/1000);
      if(_listTimer[i]<0)_listTimer[i]=0;
    }
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      for(int i=0; i< _listTimer.length;i++){
        if(_listTimer[i]>0){
          _listTimer[i]--;
        }else{
          _listTimer[i]=0;
        }
      }
      setState(() {
        _listTimer;
      });
    });
    setState(() {
      _initialize = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Giao dịch đang chờ'),
        ),
        body: _initialize
            ? Container()
            : ListView.builder(
          itemCount: _listTransactionModel.length,
          itemBuilder: (context, index) {
            final item = _listTransactionModel[index];
            final countDown = _listTimer[index];
            return OpacityButton(
              onTap: ()async {
                await Get.to(()=>BioveTransactionUpdateAdmin(item));
                initStateAsync();
              },
              child: Container(
                width: Get.width,
                height: 110,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 5),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(item.author_photoURL)
                          )
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                      SizedBox(height: 5),
                      TextUI(item.id, color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16),
                      TextUI(item.author_email, fontSize: 14,),
                      TextUI(item.author_name, fontWeight: FontWeight.bold, fontSize: 14,),
                      TextUI(item.description, fontSize: 14, color: Colors.green,),
                      TextUI(item.price,  color: Colors.redAccent, fontWeight: FontWeight.bold),
                    ]),
                    Spacer(),
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                          color: countDown==0?Colors.red:Colors.green
                      ),
                      child: Center(
                        child: TextUI('${countDown ~/ 60}:${countDown % 60}', color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20,),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer!.cancel();
  }
}
