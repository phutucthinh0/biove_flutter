import 'package:biove/widgets/button_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeDesktop extends StatefulWidget {

  @override
  _HomeDesktopState createState() => _HomeDesktopState();
}

class _HomeDesktopState extends State<HomeDesktop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Image.asset("assets/home/bg1.jpg", width: Get.width, height: Get.height,fit: BoxFit.cover),
          Container(
            height: 100,
            color: Colors.red,
            child: ButtonUI(
              text: 'BIOVE',
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
