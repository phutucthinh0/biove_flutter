import 'package:biove/controllers/admin_controller.dart';
import 'package:biove/ui/admin/biove_map_admin.dart';
import 'package:biove/ui/admin/biove_transaction_admin.dart';
import 'package:biove/ui/mobile/maptest.dart';
import 'package:biove/widgets/card_110_menu.dart';
import 'package:biove/widgets/card_510_menu.dart';
import 'package:biove/widgets/text_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

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
          Card510Menu(title: "LOẠI CÂY TRỒNG", icon: Icons.category),
          SizedBox(height: 10),
          Card510Menu(title: "THÔNG TIN CÂY", icon: Icons.park),
          SizedBox(height: 10),
          Card510Menu(title: "QUẢN LÍ GIAO DỊCH", icon: Icons.park, onTap: ()=>Get.to(()=>BioveTransactionAdmin()),),
        ],
      ),
    );
  }
}
