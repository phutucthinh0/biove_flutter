import 'dart:ui';

import 'package:biove/widgets/text_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class Privacy extends StatefulWidget {

  @override
  _PrivacyState createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: TextUI("set&pri".tr, fontWeight: FontWeight.bold, color: Colors.white,),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          TextUI('Điều khoản dịch vụ', fontWeight: FontWeight.bold),
          TextUI('Nếu tham gia trồng cây theo nhóm, thứ tự tên cá nhân người dùng sẽ hiện theo thứ tự khoản tiền người dùng đóng góp từ lớn đến bé.'),
          TextUI('Nếu trong trường hợp nhiều người dùng cùng đóng góp một khoản tiền như nhau, BIOVE sẽ sắp xếp tên người dùng theo thứ tự bảng chữ cái Tiếng Việt.', color: Colors.grey,),
          TextUI('Hàng tháng, BIOVE sẽ tự động trừ trong khoản tiền quyên góp của các bạn … VNĐ gửi đến ban chăm sóc và quản lý cây trồng của bạn nhằm cụ thể các khoản thu chi rõ ràng.'),
          TextUI('Cây trồng sau khi được bạn quyên góp chỉ mang tên của bạn, cây sẽ không thuộc quyền sử hữu của riêng bạn. Chúng tôi cung cấp các dịch vụ liên quan đến cây trồng, cụ thể như tham quan, dã ngoại, đổi tên (thừa kế),...Vì thế, bạn không thể thu hồi giá trị cây trồng dưới bất kỳ hình thức nào.')
        ],
      ),
    );
  }
}
