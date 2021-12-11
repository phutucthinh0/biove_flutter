import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:biove/apis/handle_api.dart';
import 'package:biove/data/db.dart';
import 'package:biove/routes/slide_from_left_route.dart';
import 'package:biove/ui/mobile/tab_menu.dart';
import 'package:biove/widgets/opacity_button.dart';
import 'package:biove/widgets/text_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class TabStories extends StatefulWidget {

  @override
  _TabStoriesState createState() => _TabStoriesState();
}

class _TabStoriesState extends State<TabStories> {
  final ImagePicker _picker = ImagePicker();
  XFile? imagePicker;
  bool isHaveImagePicker = false;
  String tempTextStory = "";
  TextEditingController _addStoryController = TextEditingController();
  final _addStoryFocusNode = FocusNode();
  bool isAddStoryFocus = false;
  bool isPostingStory = false;
  List<dynamic> _listStory = [];
  @override
  void initState() {
    super.initState();
    _getStory();
  }
  _getStory(){
    handleApi.GET('$root_url/story/get').then((data){
      setState(() {
        _listStory = data;
      });
    });
  }
  _addStory(){
    if(_addStoryController.text.trim().length==0)return;
    setState(() {
      isPostingStory = true;
    });
    if(isHaveImagePicker&&imagePicker!=null){
      _addStoryWithMedia();
      return;
    }
    handleApi.POST('$root_url/story/add', {
      'author_id':db.getAccountId(),
      'body':_addStoryController.text.trim(),
      'media':''
    }).then((value){
      _addStoryController.clear();
      _addStoryFocusNode.unfocus();
      setState(() {
        isPostingStory = false;
      });
      _getStory();
    });
  }
  _addStoryWithMedia(){
    handleApi.POSTASSETS('$root_url/story/upload-media', imagePicker).then((data){
      if(data['upload']){
        handleApi.POST('$root_url/story/add', {
          'author_id':db.getAccountId(),
          'body':_addStoryController.text.trim(),
          'media':data['path']
        }).then((value){
          _addStoryController.clear();
          _addStoryFocusNode.unfocus();
          imagePicker = null;
          setState(() {
            isHaveImagePicker = false;
            isPostingStory = false;
          });
          _getStory();
        });
      }
    });
  }

  _addAssets()async{
    imagePicker = await _picker.pickImage(source: ImageSource.gallery);
    if(imagePicker!=null){
      setState(() {
        isHaveImagePicker = true;
      });
    }else{
      setState(() {
        isHaveImagePicker = false;
      });
    }
  }
  _removeAssets()async{
    imagePicker=null;
    setState(() {
      isHaveImagePicker = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff7f7f7),
      body: SafeArea(
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
                    icon: Icon(Icons.menu_outlined, size: 30),
                  ),
                  Column(
                    children: [
                      SizedBox(height: 10),
                      TextUI('CÂU CHUYỆN', color: Color(0xff4da1a2), fontSize: 24, fontWeight: FontWeight.bold,),
                      Icon(Icons.expand_more_outlined, color: Color(0xff4da1a2),)
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
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: double.infinity,
              height: isAddStoryFocus?isHaveImagePicker?390:200:60,
              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Focus(
                                onFocusChange: (hasFocus){
                                  if(hasFocus){
                                    setState(() {
                                      _addStoryController.text = tempTextStory;
                                      isAddStoryFocus = true;
                                    });
                                    tempTextStory = "";
                                  }else{
                                    tempTextStory = _addStoryController.text.trim();
                                    _addStoryController.clear();
                                    setState(() {
                                      isAddStoryFocus = false;
                                    });
                                  }
                                },
                                child: TextFormField(
                                  maxLines: isAddStoryFocus?5:null,
                                  focusNode: _addStoryFocusNode,
                                  controller: _addStoryController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "wh_think".tr,
                                  ),
                                ),
                              ),
                            ),
                            Icon(Icons.place_outlined, color: Colors.grey)
                          ],
                        ),
                        if(isHaveImagePicker&&isAddStoryFocus)
                        Container(
                          width: double.infinity,
                          height: 190,
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: kIsWeb
                                    ? DecorationImage(image: NetworkImage(imagePicker!.path), fit: BoxFit.cover)
                                    : DecorationImage(image: FileImage(File(imagePicker!.path)), fit: BoxFit.cover),
                            gradient: LinearGradient(
                              colors: [Color(0xff294b6b), Color(0xff38a09d)],
                              begin: FractionalOffset(0.0, 0.0),
                              end: FractionalOffset(0.0, 1.0),
                            )
                          ),
                          child: Align(
                            alignment: Alignment.topRight,
                              child: IconButton(icon: Icon(Icons.close, color: Colors.green), onPressed: ()=>_removeAssets(),)
                          ),
                        ),
                        Spacer(),
                        if(isAddStoryFocus)
                        Row(
                          children: [
                            IconButton(onPressed: ()=>_addAssets(), icon: Icon(Icons.perm_media, color: Colors.green)),
                            Spacer(),
                            OpacityButton(
                              onTap: ()=>_addStory(),
                              child: Container(
                                width: 150,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.green
                                ),
                                child: Center(child: TextUI('post'.tr, color: Colors.white,)),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  if(isPostingStory)
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                        borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(child: TextUI('Đang tải lên...', color: Colors.white, fontWeight: FontWeight.bold,fontSize: 22,)),
                  )
                ],
              ),
            ),
            SizedBox(height: 5),
            Expanded(
              child: ListView.builder(
                itemCount: _listStory.length,
                itemBuilder: (context, index){
                  return _buildItemNewsFeed(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildItemNewsFeed(int index){
    final datetime = DateTime.fromMillisecondsSinceEpoch(_listStory[index]['date']);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateToCheck = DateTime(datetime.year, datetime.month, datetime.day);
    var format;
    if(today == dateToCheck){
      format = DateFormat('HH:mm a');
    }else{
      format = DateFormat('d/M, HH:mm a');
    }
    final clockString = format.format(datetime);
    // return without media
    if(_listStory[index]['media']==null||_listStory[index]['media']==""){
      return Container(
        margin: EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    image: DecorationImage(
                        image: NetworkImage(_listStory[index]['author_photoURL']),
                        fit: BoxFit.cover
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextUI(_listStory[index]['author_name'], color: Colors.grey, fontWeight: FontWeight.bold),
                    SizedBox(height: 8),
                    TextUI(clockString, color: Colors.grey, fontWeight: FontWeight.normal, fontSize: 12,)
                  ],
                )
              ],
            ),
            SizedBox(height: 5),
            SizedBox(height: 5),
            Container(
              width: double.infinity,
              height: 190,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [Color(0xff294b6b), Color(0xff38a09d)],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(0.0, 1.0),
                  )
              ),
              child: Center(child: TextUI(_listStory[index]['body'], color: Colors.white, fontSize: 16),),
            ),
            // SizedBox(height: 5),
            Row(
              children: [
                SizedBox(width: 8),
                IconButton(
                    onPressed: (){

                    },
                    icon: Icon(Icons.favorite_outlined, color: Colors.red)
                ),
                IconButton(
                    onPressed: (){

                    },
                    icon: Icon(Icons.chat_outlined, color: Colors.grey)
                ),
                IconButton(
                    onPressed: (){

                    },
                    icon: Icon(Icons.launch_outlined, color: Colors.grey)
                )
              ],
            )
          ],
        ),
      );
    }
  //  return have media
    return Container(
      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.green,
                  image: DecorationImage(
                      image: NetworkImage(_listStory[index]['author_photoURL']),
                      fit: BoxFit.cover
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextUI(_listStory[index]['author_name'], color: Colors.grey, fontWeight: FontWeight.bold),
                  SizedBox(height: 8),
                  TextUI(clockString, color: Colors.grey, fontWeight: FontWeight.normal, fontSize: 12,)
                ],
              )
            ],
          ),
          SizedBox(height: 5),
          TextUI(_listStory[index]['body'], color: Colors.grey, fontSize: 16),
          SizedBox(height: 5),
          Container(
            width: double.infinity,
            height: 190,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [Color(0xff294b6b), Color(0xff38a09d)],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(0.0, 1.0),
                ),
              image: DecorationImage(
                image: NetworkImage(_listStory[index]['media']),
                fit: BoxFit.cover
              )
            ),
          ),
          // SizedBox(height: 5),
          Row(
            children: [
              SizedBox(width: 8),
              IconButton(
                  onPressed: (){

                  },
                  icon: Icon(Icons.favorite_outlined, color: Colors.red)
              ),
              IconButton(
                  onPressed: (){

                  },
                  icon: Icon(Icons.chat_outlined, color: Colors.grey)
              ),
              IconButton(
                  onPressed: (){

                  },
                  icon: Icon(Icons.launch_outlined, color: Colors.grey)
              )
            ],
          )
        ],
      ),
    );
  }
}
