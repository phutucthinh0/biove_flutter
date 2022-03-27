import 'package:biove/controllers/admin_controller.dart';
import 'package:biove/ui/admin/biove_map_admin.dart';
import 'package:biove/ui/admin/biove_tranaction_failed_admin.dart';
import 'package:biove/ui/admin/biove_transaction_holding_admin.dart';
import 'package:biove/ui/admin/biove_transaction_successful_admin.dart';
import 'package:biove/widgets/card_510_menu.dart';
import 'package:biove/widgets/text_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Admin extends StatefulWidget {

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final AdminController _adminController = Get.put(AdminController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe5e5e5),
      appBar: AppBar(
        title: TextUI('QUẢN LÝ BIOVE', color: Colors.white),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Card510Menu(title: "BIOVE MAP", icon: Icons.map, onTap: ()=>Get.to(()=>BIOVEMapAdmin())),
          SizedBox(height: 10),
          // Card510Menu(title: "LOẠI CÂY TRỒNG", icon: Icons.category),
          // SizedBox(height: 10),
          // Card510Menu(title: "THÔNG TIN CÂY", icon: Icons.park),
          // SizedBox(height: 10),
          Card510Menu(title: "GIAO DỊCH CHỜ XÁC NHẬN", icon: Icons.park, onTap: ()=>Get.to(()=>BioveTransactionHoldingAdmin()),),
          SizedBox(height: 10),
          Card510Menu(title: "GIAO DỊCH HOÀN THÀNH", icon: Icons.park, onTap: ()=>Get.to(()=>BioveTransactionSuccessfulAdmin()),),
          SizedBox(height: 10),
          Card510Menu(title: "GIAO DỊCH THẤT BẠI", icon: Icons.park, onTap: ()=>Get.to(()=>BioveTransactionFailedAdmin()),),
        ],
      ),
    );
  }
}
