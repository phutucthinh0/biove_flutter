import 'dart:ui';

import 'package:biove/data/db.dart';
import 'package:biove/routes/slide_from_left_route.dart';
import 'package:biove/routes/slide_from_right_route.dart';
import 'package:biove/ui/mobile/maptest.dart';
import 'package:biove/ui/mobile/tab_menu.dart';
import 'package:biove/widgets/maps_item.dart';
import 'package:biove/widgets/opacity_button.dart';
import 'package:biove/widgets/text_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class TabHome extends StatefulWidget {
  @override
  _TabHomeState createState() => _TabHomeState();
}

class _TabHomeState extends State<TabHome> {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.asset('assets/home_video.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        _videoPlayerController.play();
        _videoPlayerController.setLooping(true);
      });
  }
  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff7f7f7),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(context, SlideFromLeftRoute(page: TabMenu()));
                      },
                      icon: Icon(Icons.menu_outlined, size: 30),
                    ),
                    Column(
                      children: [
                        SizedBox(height: 10),
                        TextUI(
                          'BIOVE',
                          color: Color(0xff4da1a2),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.mode_comment_outlined, size: 30),
                    )
                  ],
                ),
              ),
              Container(
                width: Get.width,
                height: 200,
                // decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/home/bg0.jpg'), fit: BoxFit.cover)),
                child: Stack(
                  children: [
                    _videoPlayerController.value.isInitialized
                        ? VideoPlayer(_videoPlayerController)
                        : Container(),
                    Positioned(
                        left: 10,
                        bottom: 20,
                        child: TextUI(
                          "Trồng cây cho thế hệ mai sau",
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ))
                  ],
                ),
              ),
              SizedBox(height: 5),
              Center(child: TextUI('GIỚI THIỆU', color: Color(0xff4da1a2), fontSize: 20, fontWeight: FontWeight.bold, textAlign: TextAlign.center)),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextUI("BIOVE (Biology Environmental Protection by Vietnamese for Earth) là ứng dụng công nghệ trồng rừng phi lợi nhuận đầu tiên tại Việt Nam giúp người dùng có thể trồng cây trên những cánh rừng đang cần phủ xanh.",
                    color: Color(0xff21527a), fontSize: 15, textAlign: TextAlign.justify,),
              ),
              SizedBox(height: 10),
              Center(child: TextUI('BIOVE HEATMAP', color: Color(0xff4da1a2), fontSize: 20, fontWeight: FontWeight.bold, textAlign: TextAlign.center)),
              SizedBox(height: 5),
              OpacityButton(
                onTap: ()=>Navigator.push(context, SlideFromRightRoute(page: MapTest())),
                child: Container(
                  width: Get.width,
                  child: Image.asset("assets/bg_map.jpg"),
                ),
              ),
              SizedBox(height: 20),
              Center(child: TextUI('VIẾT VỀ BIOVE', color: Color(0xff4da1a2), fontSize: 20, fontWeight: FontWeight.bold, textAlign: TextAlign.center)),
              Container(
                width: Get.width,
                height: 300,
                child: PageView(
                  children: [
                    _buildItemAbout(),
                    _buildItemAbout(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildItemAbout(){
    return Container(
      width: Get.width,
      height: 300,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextUI('Tôi yêu BIOVE', color: Colors.brown, fontWeight: FontWeight.bold, fontSize: 22),
          SizedBox(height: 18),
          TextUI('BIOVE là nơi chúng tôi đặt niềm tin hy vọng về một thế giới hạnh phúc hơn, trong lành hơn cho thế hệ mai sau', color: Color(0xff21527a), fontSize: 16),
          Spacer(),
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(db.getAccountPicture())
                  )
                ),
              ),
              SizedBox(width: 20),
              TextUI(db.getAccountName(), color: Colors.brown, )
            ],
          )
        ],
      ),
    );
  }
}
