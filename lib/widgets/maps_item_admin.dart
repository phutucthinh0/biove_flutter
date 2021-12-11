import 'package:biove/apis/handle_api.dart';
import 'package:biove/constants/icon_trees.dart';
import 'package:biove/controllers/admin_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';

class MapItemAdmin extends StatefulWidget {
  double lat;
  double long;
  bool isBaseMap;
  MapItemAdmin({required this.lat, required this.long, required this.isBaseMap});

  @override
  _MapItemAdminState createState() => _MapItemAdminState();
}

class _MapItemAdminState extends State<MapItemAdmin> {
  final AdminController _adminController = Get.find();
  late MapController _controller;
  List<LatLng> markers = [];
  List<LatLng> markersNewTree = [];
  List<dynamic> _listTrees = [];
  List<dynamic> _listNewTrees = [];
  @override
  void initState() {
    super.initState();
    _controller = MapController(
      location: LatLng(widget.lat, widget.long),
    );
  }
  void _onDoubleTap() {
    _controller.zoom += 0.5;
    setState(() {});
  }
  Offset? _dragStart;
  double _scaleStart = 1.0;
  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      _controller.zoom += 0.02;
      setState(() {});
    } else if (scaleDiff < 0) {
      _controller.zoom -= 0.02;
      setState(() {});
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart!;
      _dragStart = now;
      _controller.drag(diff.dx, diff.dy);
      setState(() {});
    }
  }
  Widget _buildMarkerWidget(Offset pos) {
    return Positioned(
      left: pos.dx - 16,
      top: pos.dy - 16,
      width: 24,
      height: 24,
      child: Icon(Icons.location_on, color: Colors.blueAccent),
    );
  }
  Widget _buildMarkerTree(Offset pos, int i) {
    return Positioned(
        left: pos.dx - 16,
        top: pos.dy - 16,
        width: 24,
        height: 24,
        child: Image.asset(IconTrees.getAssetsTreeById(_listTrees[i]['jungleType']), width: 24, height: 24,)
    );
  }
  Widget _buildMarkerNewTree(Offset pos) {
    return Positioned(
        left: pos.dx - 16,
        top: pos.dy - 16,
        width: 24,
        height: 24,
        child: Image.asset(IconTrees.getAssetsTreeById(1), width: 24, height: 24,)
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
    handleApi.GET('$root_url/new-tree/get').then((value){
      if(value!=null){
        if(value!=null){
          _listNewTrees = [];
          _listNewTrees = value;
          markersNewTree = [];
          for(dynamic e in _listNewTrees){
            markersNewTree.add(LatLng(e['latitude'], e['longitude']));
          }
          setState(() {});
        }else{
          print('Overload New Tree');
        }
      }
    });
    handleApi.POST('$root_url/tree/getMapCache', {
      'minLatitude':minLat,
      'maxLatitude':maxLat,
      'minLongitude':minLong,
      'maxLongitude':maxLong,
      'zoom':_controller.zoom
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
  @override
  Widget build(BuildContext context) {
    return MapLayoutBuilder(
      controller: _controller,
      builder: (BuildContext context, MapTransformer transformer){
        final homeLocation = transformer.fromLatLngToXYCoords(LatLng(widget.lat, widget.long));
        final homeMarkerWidget = _buildMarkerWidget(homeLocation);
        final centerLocation = Offset(transformer.constraints.biggest.width / 2, transformer.constraints.biggest.height / 2);
        final latlongCenter = transformer.fromXYCoordsToLatLng(centerLocation);
        _adminController.mapLat(latlongCenter.latitude);
        _adminController.mapLong(latlongCenter.longitude);
        final centerMarkerWidget = _buildCenterWidget(centerLocation);
        final markerPositions = markers.map(transformer.fromLatLngToXYCoords).toList();
        final markerWidgets = [];
        for (int i = 0; i < markerPositions.length; i++) {
          markerWidgets.add(_buildMarkerTree(markerPositions[i],i));
        }

        //new tree
        final markerNewTreePositions = markersNewTree.map(transformer.fromLatLngToXYCoords).toList();
        final markerNewTreeWidgets = [];
        for (int i = 0; i < markerNewTreePositions.length; i++) {
          markerWidgets.add(_buildMarkerNewTree(markerNewTreePositions[i]));
        }

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onDoubleTap: _onDoubleTap,
          onScaleStart: _onScaleStart,
          onScaleUpdate: _onScaleUpdate,
          onTapUp: (details) {
            // final a = transformer.fromXYCoordsToLatLng(Offset(transformer.constraints.smallest.width,transformer.constraints.smallest.width));
            // final b = transformer.fromXYCoordsToLatLng(Offset(transformer.constraints.biggest.width, transformer.constraints.biggest.height));
            // print('--------------------${_controller.zoom}');
            // print('-----------------------------------------------------${a.longitude}, ${a.latitude}');
            // print('+++++++++++++++++++++++++++++++++++++++++++++++++++++${b.longitude}, ${b.latitude}');
            //
            // _handleGetMap(b.latitude, a.latitude, a.longitude, b.longitude);


            // final location =
            // transformer.fromXYCoordsToLatLng(details.localPosition);
            // final clicked = transformer.fromLatLngToXYCoords(location);
            // print('${location.longitude}, ${location.latitude}');
            // print('${clicked.dx}, ${clicked.dy}');
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
                _controller.zoom -= delta.dy / 1000.0;
                setState(() {});
              }
            },
            child: Stack(
              children: [
                Map(
                  controller: _controller,
                  builder: (context, x, y, z) {
                    // final url ="https://tile.openstreetmap.org/${z}/${x}/${y}.png";
                    final url = widget.isBaseMap
                    // ?"https://tile.openstreetmap.org/${z}/${x}/${y}.png"
                        ?"https://2.base.maps.api.here.com/maptile/2.1/maptile/9ab8a6c072/normal.day/${z}/${x}/${y}/512/png8?app_id=VgTVFr1a0ft1qGcLCVJ6&app_code=LJXqQ8ErW71UsRUK3R33Ow&lg=vie&ppi=72&pview=VNM"
                        :"https://3.aerial.maps.api.here.com/maptile/2.1/maptile/9ab8a6c072/hybrid.day/${z}/${x}/${y}/512/png8?app_id=VgTVFr1a0ft1qGcLCVJ6&app_code=LJXqQ8ErW71UsRUK3R33Ow&lg=vie&ppi=72&pview=VNM";
                    return Image.network(
                      url,
                      fit: BoxFit.cover,
                    );
                  },
                ),
                homeMarkerWidget,
                ...markerWidgets,
                centerMarkerWidget,
              ],
            ),
          ),
        );
      },
    );
  }
}
