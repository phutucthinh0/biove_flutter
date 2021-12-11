import 'package:biove/widgets/text_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Develop extends StatefulWidget {

  @override
  _DevelopState createState() => _DevelopState();
}

class _DevelopState extends State<Develop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff8f8f8),
      body: Stack(
        children: [
          Positioned(
            bottom: -Get.height*0.25,
            child: Image.asset("assets/bg_0.png", width: Get.width,),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/logo.jpg", width: 120),
                SizedBox(height: 150),
                TextUI("DEVELOPING...", color: Colors.white, fontSize: 30,)
              ],
            ),
          )
        ],
      ),
    );
  }
}
