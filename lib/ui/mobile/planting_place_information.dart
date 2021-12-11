import 'package:biove/models/type_of_tree.dart';
import 'package:biove/ui/mobile/payment.dart';
import 'package:biove/widgets/opacity_button.dart';
import 'package:biove/widgets/text_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_view_indicators/page_view_indicators.dart';

class PlantingPlaceInformation extends StatefulWidget {
  TypeOfTree typeOfTree;
  PlantingPlaceInformation(this.typeOfTree);
  @override
  _PlantingPlaceInformationState createState() => _PlantingPlaceInformationState();
}

class _PlantingPlaceInformationState extends State<PlantingPlaceInformation> {
  final PageController _imgController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xffecf5fb),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: TextUI("VÙNG ĐẤT", fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      body: Stack(
        children: [
          Positioned(
            top: -80,
            child: Image.asset(
              "assets/bg_0.png",
              width: Get.width,
            ),
          ),
          Positioned(
            top: 90,
            child: Hero(
              tag: widget.typeOfTree.id,
              child: Container(
                width: Get.width,
                height: 350,
                child: PageView.builder(
                  controller: _imgController,
                  itemCount: widget.typeOfTree.images.length,
                  onPageChanged: (int index){
                    _currentPageNotifier.value = index;
                  },
                  itemBuilder: (context, index){
                    return Container(
                      width: Get.width,
                      height: 350,
                      decoration:
                      BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(image: NetworkImage(widget.typeOfTree.images[index]), fit: BoxFit.cover),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          IgnorePointer(
            child: Container(
              width: Get.width,
              height: 350,
              margin: EdgeInsets.only(top: 100),
              decoration:
              BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black87, Colors.transparent],
                    begin: FractionalOffset(0.0, 1.0),
                    end: FractionalOffset(0.0, 0.0),
                  )
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 400),
              child: TextUI(widget.typeOfTree.name, color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold,),
            ),
          ),
          Positioned(
            bottom: 400,
            left: 15,
            child: CirclePageIndicator(
              itemCount: widget.typeOfTree.images.length,
              currentPageNotifier: _currentPageNotifier,
              selectedDotColor: Colors.white,
              dotColor: Colors.white38,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: Get.width-30,
              height: 380,
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.only(top: 20,left: 10,right: 10,bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: ListView(padding: EdgeInsets.zero,children: [
                Wrap(children: [
                  TextUI('Nơi trồng: ', fontWeight: FontWeight.w800, color: Color(0xff2a5071)),
                  TextUI("Biên Hòa - Đồng Nai")
                ]),
                SizedBox(height: 10),
                Wrap(children: [
                  TextUI('Thông tin: ', fontWeight: FontWeight.w800, color: Color(0xff2a5071)),
                  TextUI(widget.typeOfTree.information)
                ]),
                SizedBox(height: 10),
                Wrap(children: [
                  TextUI('Giá cả: ', fontWeight: FontWeight.w800, color: Color(0xff2a5071)),
                  TextUI(widget.typeOfTree.price)
                ])
              ]),
            ),
          ),
          Positioned(
            right: 35,
            bottom: 370,
            child: OpacityButton(
              onTap: ()=>Get.to(()=>Payment(price: widget.typeOfTree.price,)),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color(0xff359d9e)
                ),
                child: Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 30,),
              ),
            ),
          )
        ],
      ),
    );
  }
}
