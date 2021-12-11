import 'dart:io';
import 'dart:ui';

import 'package:biove/apis/handle_api.dart';
import 'package:biove/apis/post_api.dart';
import 'package:biove/controllers/admin_controller.dart';
import 'package:biove/helpers/loading.dart';
import 'package:biove/widgets/button_ui.dart';
import 'package:biove/widgets/text_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class BIOVEMapAddTree extends StatefulWidget {
  @override
  _BIOVEMapAddTreeState createState() => _BIOVEMapAddTreeState();
}

class _BIOVEMapAddTreeState extends State<BIOVEMapAddTree> {
  AdminController _adminController = Get.find();
  ImagePicker _imagePicker = ImagePicker();
  List<XFile?> _listImage = [];
  TextEditingController _nameController = TextEditingController();
  TextEditingController _owerController = TextEditingController();
  TextEditingController _grownController = TextEditingController();
  _addImageFromCamera() async {
    XFile? newImage = await _imagePicker.pickImage(source: ImageSource.camera);
    if (newImage != null) {
      setState(() {
        _listImage.add(newImage);
      });
    }
  }

  _addImageFromGallery() async {
    XFile? newImage = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (newImage != null) {
      setState(() {
        _listImage.add(newImage);
      });
    }
  }
  _handleFinish()async{
    if(_listImage.length==0||_nameController.text.trim().length==0)return;
    String bOwer = _owerController.text.trim().length ==0?"Chưa cập nhật":_owerController.text.trim();
    String bGrown = _grownController.text.trim().length ==0?"Chưa cập nhật":_grownController.text.trim();
    Loading.show();
    List<String> _listPath = [];
    for(int i =0; i<_listImage.length; i++){
      // dynamic data = await handleApi.POSTASSETSTREE('$root_url/new-tree/upload-media', _listImage[i]);
      dynamic data = await POSTAPI.request(_listImage[i]);
      if(data['upload']){
        _listPath.add(data['path']);
      }
    };
    dynamic data = await handleApi.POST('$root_url/new-tree/add',{
      'nameID':_nameController.text.trim(),
      'owner': bOwer,
      'growdate': bGrown,
      'latitude':_adminController.mapLat.value,
      'longitude':_adminController.mapLong.value,
      'images':_listPath
    });
    print(data);
    Loading.dismiss();
    Navigator.pop(context);
  }
  @override
  void dispose() {
    Loading.dismiss();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe5e5e5),
      appBar: AppBar(
        title: TextUI('THÊM CÂY MỚI', color: Colors.white),
        actions: [
          IconButton(onPressed: ()=>_handleFinish(), icon: Icon(Icons.save))
        ],
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          margin: EdgeInsets.only(top: 10, left: 20),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          width: Get.width - 40,
          height: 45,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: TextFormField(
            controller: _nameController,
            maxLines: 2,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(isDense: true, border: InputBorder.none, hintText: "Tên cây", hintStyle: TextStyle(fontSize: 18, color: Colors.blueAccent), focusColor: Colors.white),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10, left: 20),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          width: Get.width - 40,
          height: 45,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: TextFormField(
            controller: _owerController,
            maxLines: 2,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(isDense: true, border: InputBorder.none, hintText: "Người tài trợ", hintStyle: TextStyle(fontSize: 18, color: Colors.blueAccent), focusColor: Colors.white),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10, left: 20),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          width: Get.width - 40,
          height: 45,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: TextFormField(
            controller: _grownController,
            maxLines: 2,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(isDense: true, border: InputBorder.none, hintText: "Ngày sinh của cây", hintStyle: TextStyle(fontSize: 18, color: Colors.blueAccent), focusColor: Colors.white),
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ButtonUI(
              onTap: () => _addImageFromCamera(),
              text: "Camera",
              textColor: Colors.blue,
              iconLeft: Icon(
                Icons.add,
                color: Colors.blue,
              ),
            ),
            ButtonUI(
              onTap: () => _addImageFromGallery(),
              text: "Gallery",
              textColor: Colors.blue,
              iconLeft: Icon(
                Icons.add,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
              itemCount: _listImage.length,
              itemBuilder: (context, index) {
                return Container(
                    width: Get.width - 40,
                    height: 200,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        image: DecorationImage(image: FileImage(File(_listImage[index]!.path))),
                        gradient: LinearGradient(
                          colors: [Color(0xff294b6b), Color(0xff38a09d)],
                          begin: FractionalOffset(0.0, 0.0),
                          end: FractionalOffset(0.0, 1.0),
                        )),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: (){
                          setState(() {
                            _listImage.removeAt(index);
                          });
                        },
                        icon: Icon(Icons.close, color: Colors.white,),
                      ),
                    ));
              }),
        )
        // ClipRect(
        //   child: BackdropFilter(
        //     filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        //     child: Container(
        //       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        //       width: 300,
        //       height: 45,
        //       decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)),
        //       child: TextFormField(
        //         maxLines: 2,
        //         style: TextStyle(color: Colors.white54),
        //         decoration: InputDecoration(
        //             isDense: true,
        //             border: InputBorder.none,
        //             hintText: "Tên cây",
        //             hintStyle: TextStyle(fontSize: 18, color: Colors.white54),
        //             focusColor: Colors.white),
        //       ),
        //     ),
        //   ),
        // )
      ]),
    );
  }
}
