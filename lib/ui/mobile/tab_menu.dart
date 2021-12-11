import 'dart:ui';

import 'package:biove/data/db.dart';
import 'package:biove/ui/admin/admin.dart';
import 'package:biove/ui/mobile/biove_map.dart';
import 'package:biove/ui/mobile/login.dart';
import 'package:biove/ui/mobile/maptest.dart';
import 'package:biove/ui/mobile/privacy.dart';
import 'package:biove/widgets/button_ui.dart';
import 'package:biove/widgets/card_110_menu.dart';
import 'package:biove/widgets/card_510_menu.dart';
import 'package:biove/widgets/opacity_button.dart';
import 'package:biove/widgets/text_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
class TabMenu extends StatefulWidget {

  @override
  _TabMenuState createState() => _TabMenuState();
}

class _TabMenuState extends State<TabMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff7f7f7),
      body: SafeArea(
        child: Column(
          children: [
            db.nullAccount()?_buildLogin():
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 100,
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(db.getAccountPicture()),
                          fit: BoxFit.cover
                        )
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextUI(db.getAccountName(), color: Colors.grey, fontWeight: FontWeight.bold),
                      SizedBox(height: 8),
                      TextUI('view_profile'.tr, color: Colors.grey, fontWeight: FontWeight.normal, fontSize: 12)
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card110Menu(title: "wallet".tr, icon: Icons.account_balance_wallet_outlined),
                Card110Menu(title: "scanning".tr, icon: Icons.qr_code_scanner_outlined),
                Card110Menu(title: "biove_map".tr, icon: Icons.map_outlined, onTap: ()=>Get.to(()=>MapTest())),
              ],
            ),
            SizedBox(height: 30),
            Card510Menu(title: "Quản lý BIOVE".tr, icon: Icons.admin_panel_settings, onTap: ()=>Get.to(()=>Admin())),
            SizedBox(height: 10),
            Card510Menu(title: "rp&sp".tr, icon: Icons.live_help_outlined),
            SizedBox(height: 10),
            Card510Menu(title: "set&pri".tr, icon: Icons.share_outlined, onTap: ()=>Get.to(()=>Privacy())),
            SizedBox(height: 10),
            Card510Menu(title: "Honor Board", icon: Icons.assignment_ind_outlined),
            SizedBox(height: 10),
            Card510Menu(title: "lang".tr, icon: Icons.language_outlined),
            SizedBox(height: 10),
            Card510Menu(title: "logout".tr, icon: Icons.logout_outlined, onTap: ()=>db.logout(),),
          ],
        ),
      ),
    );
  }
  Widget _buildLogin() => OpacityButton(
    onTap: (){
      Get.off(()=>Login());
    },
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 60,
      color: Colors.white,
      child: Center(
        child: TextUI(
          'ĐĂNG NHẬP BIOVE',
          color: Color(0xff4da1a2),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
