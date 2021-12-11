import 'dart:ui';

import 'package:biove/apis/handle_api.dart';
import 'package:biove/data/db.dart';
import 'package:biove/widgets/circle_loading.dart';
import 'package:biove/widgets/text_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class InfoTree extends StatefulWidget {
  ImagePicker imagePicker = ImagePicker();
  String tree_id;
  bool navWithQuery;
  InfoTree({this.tree_id = '619b83c465b9be071a2cdc6f', this.navWithQuery = false});
  @override
  _InfoTreeState createState() => _InfoTreeState();
}

class _InfoTreeState extends State<InfoTree> {
  dynamic infoTree;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    if(widget.navWithQuery){
      widget.tree_id = db.query['q']as String;
    }
    handleApi.GET('$root_url/new-tree/get?q=${widget.tree_id}').then((value){
      if(value!=null){
        setState(() {
          isLoading = false;
          infoTree = value;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xfff7f7f7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: TextUI("TREES HOME", fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
      ),
      body: isLoading?Center(child: CircleLoading()):
      Stack(
        children: [
          Positioned(
            top: -100,
            child: Image.asset("assets/bg_0.png", width: Get.width,),
          ),
          Align(
            alignment:Alignment.topCenter,
            child: Container(margin: EdgeInsets.only(top: 75),child: TextUI(infoTree['name'], color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold,)),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.only(top: 100),
              padding: EdgeInsets.all(10),
              width: Get.width-20,
              height: 600,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ]
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextUI("Người tài trợ: ", color: Color(0xff21527a),fontWeight: FontWeight.bold),
                    SizedBox(height: 5),
                    TextUI(infoTree['owner'], color: Color(0xff4a4a4a)),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        TextUI("Ngày sinh của cây: ", color: Color(0xff21527a),fontWeight: FontWeight.bold),
                        TextUI(infoTree['growndate'], color: Color(0xff4a4a4a)),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextUI("Đặc tính sinh học: ", color: Color(0xff21527a),fontWeight: FontWeight.bold),
                    SizedBox(height: 5),
                    TextUI(infoTree['information'], color: Color(0xff4a4a4a)),
                    SizedBox(height: 10),
                    TextUI("Hình ảnh của cây: ", color: Color(0xff21527a),fontWeight: FontWeight.bold),
                    SizedBox(height: 5),
                    Container(
                      width: Get.width-20,
                      height: 500,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: infoTree['images'].length,
                        itemBuilder: (context, index){
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Image.network(infoTree['images'][index])
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
