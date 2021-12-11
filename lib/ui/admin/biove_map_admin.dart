import 'dart:async';
import 'dart:ui';

import 'package:biove/controllers/admin_controller.dart';
import 'package:biove/helpers/dialog.dart';
import 'package:biove/helpers/loading.dart';
import 'package:biove/routes/slide_from_right_route.dart';
import 'package:biove/ui/admin/biove_map_add_tree.dart';
import 'package:biove/widgets/button_ui.dart';
import 'package:biove/widgets/maps_item_admin.dart';
import 'package:biove/widgets/text_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class BIOVEMapAdmin extends StatefulWidget {
  @override
  _BIOVEMapAdminState createState() => _BIOVEMapAdminState();
}

class _BIOVEMapAdminState extends State<BIOVEMapAdmin> {
  final AdminController _adminController = Get.find();
  Location location = new Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  bool isLoading = true;
  bool isRealtime = false;
  bool isMapBase = true;
  @override
  void initState() {
    super.initState();
    initALL();
  }

  Future<void> initALL() async {
    Loading.show();
    location.enableBackgroundMode(enable: false);
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    // location.onLocationChanged.listen((LocationData currentLocation) {
    //   if(isRealtime){
    //     setState(() {
    //       _locationData = currentLocation;
    //     });
    //   }
    // });
    Loading.dismiss();
    setState(() {
      isLoading = false;
    });
  }
  _handleRealTime(){
    if(isRealtime){
      setState(() {
        isRealtime = false;
      });
    }else{
      ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
        content: TextUI('Định vị thời gian thực: BẬT', color: Colors.black,),
        leading: const Icon(Icons.info),
        backgroundColor: Colors.yellowAccent,
        actions: [
          TextButton(
            child: const Text('Dismiss'),
            onPressed: () => ScaffoldMessenger.of(context)
                .hideCurrentMaterialBanner(),
          ),
        ],
        onVisible: (){
          Future.delayed(Duration(seconds: 2),(){
            ScaffoldMessenger.of(context)
                .hideCurrentMaterialBanner();
          });
        },
      ));
      setState(() {
        isRealtime = true;
      });
    }
  }
  @override
  void dispose() {
    super.dispose();
    Loading.dismiss();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextUI('BIOVE MAP', color: Colors.white),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.info_outlined),
          ),
          IconButton(
            onPressed: ()=>_handleRealTime(),
            icon: Icon(Icons.watch, color: isRealtime?Colors.red:Colors.white,),
          )
        ],
      ),
      body: isLoading?Container(child: Center(child: ButtonUI(text: 'Cấp quyền vị trí', onTap: ()=>initALL())),):
      Column(
        children: [
          // SizedBox(height: 10),
          // Row(children: [
          //   SizedBox(width: 10),
          //   TextUI(
          //     'Tổng số cây:',
          //     color: Colors.blueAccent,
          //     fontWeight: FontWeight.bold,
          //   )
          // ]),
          // SizedBox(height: 10),
          // Row(children: [
          //   SizedBox(width: 10),
          //   TextUI(
          //     'Lat: ${_locationData.latitude}',
          //     color: Colors.blueAccent,
          //     fontWeight: FontWeight.bold,
          //   ),
          //   SizedBox(width: 10),
          //   TextUI(
          //     'Long: ${_locationData.longitude}',
          //     color: Colors.blueAccent,
          //     fontWeight: FontWeight.bold,
          //   )
          // ]),
          Expanded(child: MapItemAdmin(lat: _locationData.latitude as double, long: _locationData.longitude as double, isBaseMap: isMapBase,))
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
            onPressed: ()=>dialogAnimationWrapper(
                context: context,
                slideFrom: 'bottom',
                paddingTop: Get.height-450,
                child: Container(
                  width: Get.width-20,
                  height: 280,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                  decoration: BoxDecoration(
                      color: Color(0xff28303b),
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: Offset(0, 3), // changes position of shadow
                        )//
                      ]
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          TextUI('Chế độ xem bản đồ', color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20,),
                          Spacer(),
                          GestureDetector(onTap: ()=>Get.back(),child: Icon(Icons.close, size: 35, color: Colors.white,))
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                isMapBase = true;
                              });
                              _adminController.isBaseMap(true);
                            },
                            child: Obx(
                              ()=>Container(
                                width: 160,
                                height: 90,
                                decoration: BoxDecoration(
                                  border: Border.all(color: !_adminController.isBaseMap.value?Colors.transparent:Colors.blueAccent, width: 2),
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(image: AssetImage('assets/ic_map_base.jpg'), fit: BoxFit.cover)
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                isMapBase = false;
                              });
                              _adminController.isBaseMap(false);
                            },
                            child: Obx(
                              ()=>Container(
                                width: 160,
                                height: 90,
                                decoration: BoxDecoration(
                                  border: Border.all(color: _adminController.isBaseMap.value?Colors.transparent:Colors.blueAccent, width: 2),
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(image: AssetImage('assets/ic_map_aerial.jpg'), fit: BoxFit.cover)
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Obx(
                        ()=> Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextUI('Mặc định', color: !_adminController.isBaseMap.value?Colors.white:Colors.blueAccent, fontWeight: FontWeight.w800, fontSize: 12,),
                              TextUI('Vệ tinh ', color: _adminController.isBaseMap.value?Colors.white:Colors.blueAccent, fontWeight: FontWeight.w800, fontSize: 12,)
                            ]
                        ),
                      )
                    ],
                  ),
                )
            ),
            backgroundColor: Colors.green,
            child: Icon(Icons.layers_sharp),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: ()=>Navigator.push(context, SlideFromRightRoute(page: BIOVEMapAddTree())),
            backgroundColor: Colors.green,
            child: Icon(Icons.add),
          )
        ],
      ),
    );
  }
}
