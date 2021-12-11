
import 'package:biove/controllers/biove_controller.dart';
import 'package:biove/data/db.dart';
import 'package:biove/ui/mobile/develop.dart';
import 'package:biove/ui/mobile/info_tree.dart';
import 'package:biove/ui/mobile/login.dart';
import 'package:biove/ui/mobile/tab_home.dart';
import 'package:biove/ui/mobile/tab_planting.dart';
import 'package:biove/ui/mobile/tab_stories.dart';
import 'package:biove/ui/mobile/tab_user_bag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
class HomeMobile extends StatefulWidget {

  @override
  _HomeMobileState createState() => _HomeMobileState();
}

class _HomeMobileState extends State<HomeMobile>  with TickerProviderStateMixin {
  late TabController _tabController;
  final BioveController _mapController = Get.put(BioveController());
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if(kIsWeb){
        print(db.query);
        if(db.query.length!=0){
          Get.to(()=>InfoTree(navWithQuery: true));
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(icon: Icon(Icons.home_outlined, color: Color(0xff395a6a))),
          Tab(icon: Icon(Icons.feed_outlined, color: Color(0xff395a6a))),
          Tab(icon: Icon(Icons.volunteer_activism_rounded, color: Color(0xff395a6a))),
          Tab(icon: Icon(Icons.notifications_outlined, color: Color(0xff395a6a))),
          Tab(icon: Icon(Icons.business_center_outlined, color: Color(0xff395a6a))),
        ],
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          TabHome(),
          TabStories(),
          // Login(),
          TabPlanting(),
          Develop(),
          TabUserBag(),
        ],
      ),
    );
  }
}
