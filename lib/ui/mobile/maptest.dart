import 'dart:ui';

import 'package:biove/apis/handle_api.dart';
import 'package:biove/constants/icon_trees.dart';
import 'package:biove/controllers/biove_controller.dart';
import 'package:biove/helpers/dialog.dart';
import 'package:biove/ui/mobile/info_tree.dart';
import 'package:biove/widgets/button_ui.dart';
import 'package:biove/widgets/text_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';
import 'package:url_launcher/url_launcher.dart';

class MapTest extends StatefulWidget {
  @override
  _MapTestState createState() => _MapTestState();
}

class _MapTestState extends State<MapTest> {
  final BioveController _bioveController = Get.find();
  late bool isBaseMap;
  MapController controller = MapController(
    location: LatLng(11.001059291521528, 107.23640188434801),
    zoom: 9.52,
  );
  FocusNode _focusNode = FocusNode();
  List<dynamic> _listTrees = [];
  List<LatLng> markers = [];
  // NewTree
  List<dynamic> _listCacheNameID = [];
  List<dynamic> _listNewTrees = [];
  List<dynamic> _listSearch = [];
  List<LatLng> markersNew = [];
  Widget _buildMarkerTreeNew(Offset pos, int i) {
    return Positioned(
        left: pos.dx - 16,
        top: pos.dy - 16,
        width: 24,
        height: 24,
        child: GestureDetector(onTap: ()=>_handleSelectedTreeNew(i),child: Image.asset(IconTrees.getAssetsTreeById(1), width: 24, height: 24,))
    );
  }
  _handleSelectedTreeNew(int index) {
    final infoTree = _listNewTrees[index];
    dialogAnimationWrapper(
        slideFrom: "bottom",
        context: context,
        child: Container(
          width: Get.width - 20,
          height: 600,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white, boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ]),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Wrap(
                //   children: [
                //     TextUI("Tên Cây: ", color: Color(0xff21527a),fontWeight: FontWeight.bold),
                //     TextUI(infoTree['nameID'], color: Color(0xff4a4a4a)),
                //   ],
                // ),
                Wrap(
                  children: [
                    TextUI("Người tài trợ: ", color: Color(0xff21527a),fontWeight: FontWeight.bold),
                    TextUI(infoTree['owner'], color: Color(0xff4a4a4a)),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    TextUI("Ngày sinh của cây: ", color: Color(0xff21527a),fontWeight: FontWeight.bold),
                    TextUI(infoTree['growndate'], color: Color(0xff4a4a4a)),
                  ],
                ),
                // SizedBox(height: 10),
                // TextUI("Đặc tính sinh học: ", color: Color(0xff21527a),fontWeight: FontWeight.bold),
                // SizedBox(height: 5),
                // TextUI(infoTree['description'], color: Color(0xff4a4a4a)),
                SizedBox(height: 10),
                TextUI("Hình ảnh của cây: ", color: Color(0xff21527a),fontWeight: FontWeight.bold),
                SizedBox(height: 5),
                Container(
                  width: Get.width-20,
                  height: 410,
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
                ),
                SizedBox(height: 20),
                Center(
                  child: ButtonUI(
                    onTap: (){
                      Get.back();
                      Get.to(()=>InfoTree(tree_id: _listNewTrees[index]['_id'],));
                    },
                    backgroundColor: Colors.green,
                    text: "  Thông tin chi tiết  ",
                    textColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ButtonUI(
                    onTap: (){
                      Get.back();
                      launch("https://maps.google.com/?q=${_listNewTrees[index]['latitude']},${_listNewTrees[index]['longitude']}");
                      // Get.to(()=>InfoTree(tree_id: _listNewTrees[index]['_id'],));
                    },
                    backgroundColor: Colors.blue,
                    text: "  Đường đi  ",
                    textColor: Colors.white,
                  ),
                ),
                SizedBox(height: 5)
              ],
            ),
          ),
        ));
  }
  //EndNewTree
  void _onDoubleTap() {
    controller.zoom += 0.5;
    setState(() {});
  }
  Offset? _dragStart;
  double _scaleStart = 1.0;
  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  @override
  void initState() {
    super.initState();
    isBaseMap = _bioveController.isBaseMap.value;
    _handleGetMap(10.256035656626636, 11.755820115340057,  106.80851767513852, 107.5965634129621);
  }

  void _getSearch(String value)async{
    if(value==""){
    setState(() {
      _listSearch = _listNewTrees;
    });
    }else{
      _listSearch = [];
      for (dynamic item in _listNewTrees){
        if(item['owner'].toString().toLowerCase().contains(value.toLowerCase())){
          _listSearch.add(item);
        }
      }
      setState(() {
        _listSearch;
      });
    }
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      controller.zoom += 0.02;
      setState(() {});
    } else if (scaleDiff < 0) {
      controller.zoom -= 0.02;
      setState(() {});
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart!;
      _dragStart = now;
      controller.drag(diff.dx, diff.dy);
      setState(() {});
    }
  }
  Widget _buildMarkerWidget(Offset pos) {
    return Positioned(
      left: pos.dx - 16,
      top: pos.dy - 16,
      width: 24,
      height: 24,
      child: Icon(Icons.location_on, color: Colors.redAccent),
    );
  }
  Widget _buildMarkerTree(Offset pos, int i) {
    return Positioned(
        left: pos.dx - 16,
        top: pos.dy - 16,
        width: 24,
        height: 24,
        child: GestureDetector(onTap: ()=>_handleSelectedTree(i),child: Image.asset(IconTrees.getAssetsTreeById(_listTrees[i]['jungleType']), width: 24, height: 24,))
    );
  }
  Widget _buildCenterWidget(Offset pos) {
    return Positioned(
      left: pos.dx - 16,
      top: pos.dy - 16,
      width: 24,
      height: 24,
      child: Icon(Icons.location_on, color: Colors.redAccent),
    );
  }
  _handleGetMap(double minLat, double maxLat, double minLong, double maxLong){
    //new tree
    handleApi.GET('$root_url/new-tree/get').then((value){
      if(value!=null){
        if(value!=null){
          _listNewTrees = [];
          _listNewTrees = value;
          markersNew = [];
          for(dynamic e in _listNewTrees){
            markersNew.add(LatLng(e['latitude'], e['longitude']));
          }
          setState(() {});
        }else{
          print('Overload New Tree');
        }
      }
    });
    //end new tree
    handleApi.POST('$root_url/tree/getMapCache', {
      'minLatitude':minLat,
      'maxLatitude':maxLat,
      'minLongitude':minLong,
      'maxLongitude':maxLong,
      'zoom':controller.zoom
    }).then((value){
      if(value!=null){
        _listTrees = [];
        _listTrees = value;
        markers = [];
        for(dynamic e in _listTrees){
          markers.add(LatLng(e['latitude'], e['longitude']));
        }
        setState(() {});
      }else{
        print('Overload');
      }
    });
  }

  _handleSelectedTree(int index) {
    showDialogWithNameID(index);
  }
  showDialogWithNameID(int index){
    final infoTree = _listTrees[index];
    dialogAnimationWrapper(
        slideFrom: "bottom",
        context: context,
        child: Container(
          width: Get.width - 20,
          height: 600,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white, boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ]),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  children: [
                    TextUI("Người tài trợ: ", color: Color(0xff21527a),fontWeight: FontWeight.bold),
                    TextUI(infoTree['owner'], color: Color(0xff4a4a4a)),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    TextUI("Ngày sinh của cây: ", color: Color(0xff21527a),fontWeight: FontWeight.bold),
                    // TextUI(infoTree['growndate'], color: Color(0xff4a4a4a)),
                  ],
                ),
                SizedBox(height: 10),
                TextUI("Đặc tính sinh học: ", color: Color(0xff21527a),fontWeight: FontWeight.bold),
                SizedBox(height: 5),
                // TextUI(infoTree['description'], color: Color(0xff4a4a4a)),
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
        ));
  }
  _handleChangeBaseMap(bool b){
    setState(() {
      isBaseMap = b;
    });
    _bioveController.isBaseMap(b);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          dialogAnimationWrapper(
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
                      GestureDetector(onTap: ()=>Get.back(), child: Icon(Icons.close, size: 35, color: Colors.white,))
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: ()=>_handleChangeBaseMap(true),
                        child: Obx(
                          ()=> Container(
                            width: 160,
                            height: 90,
                            decoration: BoxDecoration(
                              border: Border.all(color: !_bioveController.isBaseMap.value ?Colors.transparent:Colors.blueAccent, width: 2),
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(image: AssetImage('assets/ic_map_base.jpg'), fit: BoxFit.cover)
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: ()=>_handleChangeBaseMap(false),
                        child: Obx(
                          ()=> Container(
                            width: 160,
                            height: 90,
                            decoration: BoxDecoration(
                                border: Border.all(color: _bioveController.isBaseMap.value?Colors.transparent:Colors.blueAccent, width: 2),
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
                        TextUI('Mặc định', color: !_bioveController.isBaseMap.value?Colors.white:Colors.blueAccent, fontWeight: FontWeight.w800, fontSize: 12,),
                        TextUI('Vệ tinh ', color: _bioveController.isBaseMap.value?Colors.white:Colors.blueAccent, fontWeight: FontWeight.w800, fontSize: 12,)
                      ]
                    ),
                  )
                ],
              ),
            )
          );
        },

        backgroundColor: Colors.blueGrey,
        child: Icon(Icons.layers_sharp, color: Colors.white,),
      ),
      body: Stack(
        children: [
          MapLayoutBuilder(
            controller: controller,
            builder: (context, MapTransformer transformer) {
              // final homeLocation = transformer.fromLatLngToXYCoords(LatLng(widget.lat, widget.long));
              // final homeMarkerWidget = _buildMarkerWidget(homeLocation);
              final centerLocation = Offset(transformer.constraints.biggest.width / 2, transformer.constraints.biggest.height / 2);
              final centerMarkerWidget = _buildCenterWidget(centerLocation);
              final markerPositions = markers.map(transformer.fromLatLngToXYCoords).toList();
              final markerWidgets = [];
              for (int i = 0; i < markerPositions.length; i++) {
                markerWidgets.add(_buildMarkerTree(markerPositions[i],i));
              }
              //new tree
              final marketPositionsNew = markersNew.map(transformer.fromLatLngToXYCoords).toList();
              final marketWidgetsNew = [];
              for (int i = 0; i < marketPositionsNew.length; i++) {
                marketWidgetsNew.add(_buildMarkerTreeNew(marketPositionsNew[i],i));
              }
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onDoubleTap: _onDoubleTap,
                onScaleStart: _onScaleStart,
                onScaleUpdate: _onScaleUpdate,
                onTapUp: (details) {
                  // final location = transformer.fromXYCoordsToLatLng(details.localPosition);
                  // final location = transformer.fromXYCoordsToLatLng(centerLocation);
                  //
                  // final clicked = transformer.fromLatLngToXYCoords(location);
                  //
                  // print('${clicked.la}, ${centerLocation.latitude}');
                  // print('${location.latitude}, ${location.longitude}');
                  // print(controller.zoom.toString());
                  // print('${details.localPosition.dx}, ${details.localPosition.dy}');
                },
                child: Listener(
                  behavior: HitTestBehavior.opaque,
                  onPointerUp: (e){
                    final a = transformer.fromXYCoordsToLatLng(Offset(transformer.constraints.smallest.width,transformer.constraints.smallest.width));
                    final b = transformer.fromXYCoordsToLatLng(Offset(transformer.constraints.biggest.width, transformer.constraints.biggest.height));
                    _handleGetMap(b.latitude, a.latitude, a.longitude, b.longitude);
                  },
                  onPointerSignal: (event) {
                    if (event is PointerScrollEvent) {
                      final delta = event.scrollDelta;

                      controller.zoom -= delta.dy / 1000.0;
                      setState(() {});
                    }
                  },
                  child: Stack(
                    children: [
                      Map(
                        controller: controller,
                        builder: (context, x, y, z) {
                          // final url = "https://tile.openstreetmap.org/${z}/${x}/${y}.png?&lg=vi";
                          // final url = "https://2.base.maps.api.here.com/maptile/2.1/maptile/9ab8a6c072/normal.day/${z}/${x}/${y}/512/png8?app_id=VgTVFr1a0ft1qGcLCVJ6&app_code=LJXqQ8ErW71UsRUK3R33Ow&lg=vie&ppi=72&pview=VNM";
                          // final url = "https://3.aerial.maps.api.here.com/maptile/2.1/maptile/9ab8a6c072/hybrid.day/${z}/${x}/${y}/512/png8?app_id=VgTVFr1a0ft1qGcLCVJ6&app_code=LJXqQ8ErW71UsRUK3R33Ow&lg=vie&ppi=72&pview=VNM";
                          final url = isBaseMap
                              // ?"https://tile.openstreetmap.org/${z}/${x}/${y}.png"
                              ?"https://2.base.maps.api.here.com/maptile/2.1/maptile/4e5f275107/normal.day/${z}/${x}/${y}/512/png8?app_id=VgTVFr1a0ft1qGcLCVJ6&app_code=LJXqQ8ErW71UsRUK3R33Ow&lg=vie&ppi=72&pview=VNM"
                              :"https://3.aerial.maps.api.here.com/maptile/2.1/maptile/4e5f275107/hybrid.day/${z}/${x}/${y}/512/png8?app_id=VgTVFr1a0ft1qGcLCVJ6&app_code=LJXqQ8ErW71UsRUK3R33Ow&lg=vie&ppi=72&pview=VNM";
                          return Image.network(
                            url,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                      // homeMarkerWidget,
                      ...markerWidgets,
                      ...marketWidgetsNew,
                      // centerMarkerWidget,
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 50,
            left: 10,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  width: Get.width-20,
                  height: 45,
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)),
                  child: Focus(
                    child: TextFormField(
                      maxLines: 1,
                      focusNode: _focusNode,
                      style: TextStyle(color: Colors.white54),
                      onChanged: (value)=>_getSearch(value),
                      decoration: InputDecoration(
                          isDense: true, border: InputBorder.none, hintText: "Tìm kiếm cây ở đây", hintStyle: TextStyle(fontSize: 18, color: Colors.white54), focusColor: Colors.white),
                    ),
                    onFocusChange: (hasFocus){
                      if(hasFocus){
                        _getSearch("");
                      }else{
                        setState(() {
                          _listSearch = [];
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          if(_listSearch.length>0)
          Positioned(
            top: 95,
            left: 10,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  width: Get.width-20,
                  height: 500,
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)),
                  child: ListView.builder(
                    itemCount: _listNewTrees.length,
                    itemBuilder: (context,index){
                      return ButtonUI(
                        text: _listNewTrees[index]['owner'],
                        textColor: Colors.white,
                        onTap: (){
                          _focusNode.unfocus();
                          controller = MapController(
                            location: LatLng(_listNewTrees[index]['latitude'], _listNewTrees[index]['longitude']),
                            zoom: 12,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          )

        ],
      ),
    );
  }

}
