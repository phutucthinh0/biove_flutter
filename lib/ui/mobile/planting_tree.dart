import 'dart:ui';

import 'package:biove/apis/handle_api.dart';
import 'package:biove/helpers/loading.dart';
import 'package:biove/models/type_of_tree.dart';
import 'package:biove/ui/mobile/planting_place_information.dart';
import 'package:biove/widgets/opacity_button.dart';
import 'package:biove/widgets/text_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:transformer_page_view_tv/transformer_page_view.dart';
// import 'package:transformer_page_view/transformer_page_view.dart';

class PlantingTree extends StatefulWidget {
  @override
  _PlantingTreeState createState() => _PlantingTreeState();
}

class _PlantingTreeState extends State<PlantingTree> {
  List<TypeOfTree> _listTypeOfTree = [];

  @override
  void initState() {
    super.initState();
    Loading.show();
    handleApi.GET("$root_url/typeoftree/get").then((value) {
      for (var item in value) {
        _listTypeOfTree.add(TypeOfTree.init(item));
      }
      setState(() {
        _listTypeOfTree;
      });
      Loading.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: TextUI("CHỌN CÂY", fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      backgroundColor: Color(0xfff7f7f7),
      body: Stack(
        children: [
          Positioned(
            top: -100,
            child: Image.asset(
              "assets/bg_0.png",
              width: Get.width,
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            margin: EdgeInsets.only(top: 100),
            child: Column(
              children: [
                SizedBox(height: 20),
                Container(
                  width: Get.width - 60,
                  height: 2,
                  color: Colors.white54,
                ),
                SizedBox(height: 20),
                // ClipRect(
                //   child: BackdropFilter(
                //     filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                //     child: Container(
                //       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                //       width: 300,
                //       height: 45,
                //       decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)),
                //       child: TextFormField(
                //         maxLines: 1,
                //         style: TextStyle(color: Colors.white54),
                //         decoration: InputDecoration(
                //             isDense: true, border: InputBorder.none, hintText: "Tìm kiếm cây ở đây", hintStyle: TextStyle(fontSize: 18, color: Colors.white54), focusColor: Colors.white),
                //       ),
                //     ),
                //   ),
                // ),
                Expanded(
                  child: TransformerPageView(
                    // transformer: ScaleAndFadeTransformer(),
                    viewportFraction: 0.9,
                    itemCount: _listTypeOfTree.length,
                    itemBuilder: (context, index) {
                      return OpacityButton(
                        onTap: ()=>Get.to(()=>PlantingPlaceInformation(_listTypeOfTree[index])),
                        child: Hero(
                          tag: _listTypeOfTree[index].id,
                          child: Container(
                            width: 100,
                            height: 500,
                            padding: EdgeInsets.only(bottom: 20),
                            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                            decoration:
                            BoxDecoration(borderRadius: BorderRadius.circular(20), image: DecorationImage(image: NetworkImage(_listTypeOfTree[index].images[0]), fit: BoxFit.cover)),
                            child: Align(alignment: Alignment.bottomCenter ,child: TextUI(_listTypeOfTree[index].name, color: Colors.white, fontWeight: FontWeight.bold,)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildList() {
    return PageView.builder(
      itemCount: _listTypeOfTree.length,
      itemBuilder: (context, index) {
        return Container(
          width: 100,
          height: 500,
          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
        );
      },
    );
  }
}
