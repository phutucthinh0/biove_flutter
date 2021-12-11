import 'package:biove/ui/mobile/info_tree.dart';
import 'package:biove/ui/mobile/planting_place.dart';
import 'package:biove/widgets/text_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabPlanting extends StatefulWidget {
  @override
  _TabPlantingState createState() => _TabPlantingState();
}

class _TabPlantingState extends State<TabPlanting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                FloatingActionButton.extended(
                  onPressed: () => Get.to(() => PlantingPlace()),
                  label: TextUI("CHỌN ĐẤT", color: Colors.white,),
                  backgroundColor: Colors.green,
                ),
                SizedBox(height: 20),
                FloatingActionButton.extended(
                  onPressed: () => Get.to(() => PlantingPlace()),
                  label: TextUI("CHỌN CÂY", color: Colors.white,),
                  backgroundColor: Colors.green,
                ),
                // FloatingActionButton.extended(onPressed: ()=>Get.to(()=>PlantingPlace()), label: TextUI("Place")),
                // FloatingActionButton.extended(onPressed: ()=>Get.to(()=>InfoTree()), label: TextUI("info")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
