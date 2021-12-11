import 'dart:ui';

import 'package:biove/routes/slide_from_left_route.dart';
import 'package:biove/ui/mobile/tab_menu.dart';
import 'package:biove/widgets/text_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabUserBag extends StatefulWidget {

  @override
  _TabUserBagState createState() => _TabUserBagState();
}

class _TabUserBagState extends State<TabUserBag> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffecf5fb),
      body: Stack(
        children: [
          Positioned(
            top: -100,
            child: Image.asset("assets/bg_0.png", width: Get.width,),
          ),
          SafeArea(
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: (){
                          Navigator.push(context, SlideFromLeftRoute(page: TabMenu()));
                        },
                        icon: Icon(Icons.menu_outlined, size: 30, color: Colors.white,),
                      ),
                      Column(
                        children: [
                          SizedBox(height: 10),
                          TextUI('USER BAG', color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold,),
                        ],
                      ),
                      IconButton(
                        onPressed: (){

                        },
                        icon: Icon(Icons.mode_comment_outlined, size: 30),
                      )
                    ],
                  ),
                ),
                TextUI('BABY GROWING TREE', color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14,),
                Icon(Icons.expand_more_outlined, color: Colors.white,),
                SizedBox(height: 20),
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                      width: 300,
                      height: 45,
                      decoration: BoxDecoration(
                          color: Colors.white24,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: TextFormField(
                        maxLines: 1,
                        style: TextStyle(color: Colors.white54),
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: "Search for the trees here",
                          hintStyle: TextStyle(fontSize: 18, color: Colors.white54),
                          focusColor: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Container(width: 340, child: TextUI('• Pinus Kesiya Royle', color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold,)),
                SizedBox(height: 10),
                _buildCard(),
                SizedBox(height: 40),
                Container(width: 340, child: TextUI('• Pinus Kesiya Royle', color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold,)),
                SizedBox(height: 10),
                _buildCard(),
                SizedBox(height: 40),
                _buildCard(),
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget _buildCard(){
    return Container(
      width: 350,
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              TextUI('Monipolism Popcorn', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff545454)),
              Spacer(),
              Row(
                children: [
                  TextUI('Tree status: ', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff545454)),
                  TextUI('good', fontSize: 14,fontWeight: FontWeight.w200, color: Color(0xff545454)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  TextUI('Last update: ', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff545454)),
                  TextUI('2 house ago', fontSize: 14,fontWeight: FontWeight.w200, color: Color(0xff545454)),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(top: 20, right: 10),
            child: TextUI('• • •', color: Color(0xff545454)),
          ),
          Container(
            width: 80,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              image: DecorationImage(
                image: AssetImage('assets/sapa.jpg'),
                fit: BoxFit.cover
              )
            ),
          )
        ],
      ),
    );
  }
}
