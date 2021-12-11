import 'package:flutter_easyloading/flutter_easyloading.dart';

class Loading{
  static show(){
    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);
  }
  static dismiss(){
    EasyLoading.dismiss();
  }
}