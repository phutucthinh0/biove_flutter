import 'package:biove/helpers/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class BioveMap extends StatefulWidget {

  @override
  _BioveMapState createState() => _BioveMapState();
}

class _BioveMapState extends State<BioveMap> {
  _handleSelectedTree(){
    dialogAnimationWrapper(
      slideFrom: "bottom",
      context: context,
      child: Container(
        width: 500,
        height: 500,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(20)
        ),
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        child: Flexible(
          child: FlutterMap(
            options: MapOptions(
              center: LatLng(10.957480, 106.863388),
              zoom: 13
            ),
            layers: [
              TileLayerOptions(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayerOptions(
                markers: [
                  // Marker(
                  //   width: 80.0,
                  //   height: 80.0,
                  //   point: LatLng(10.957480, 106.863388),
                  //   builder: (ctx) =>
                  //       Container(
                  //         child: Image.asset('assets/ic_tree.png'),
                  //       ),
                  // ),
                  // Marker(
                  //   width: 80.0,
                  //   height: 80.0,
                  //   point: LatLng(10.957047, 106.863135),
                  //   builder: (ctx) =>
                  //       Container(
                  //         child: Image.asset('assets/ic_tree.png'),
                  //       ),
                  // ),
                  // Marker(
                  //   width: 80.0,
                  //   height: 80.0,
                  //   point: LatLng(10.957345, 106.862864),
                  //   builder: (ctx) =>
                  //       Container(
                  //         child: Image.asset('assets/ic_tree.png'),
                  //       ),
                  // ),
                  // Marker(
                  //   width: 80.0,
                  //   height: 80.0,
                  //   point: LatLng(10.957311, 106.862867),
                  //   builder: (ctx) =>
                  //       Container(
                  //         child: Image.asset('assets/ic_tree.png'),
                  //       ),
                  // ),
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(10.957409, 106.862843),
                    builder: (ctx) =>
                        GestureDetector(
                          onTap: (){
                            _handleSelectedTree();
                          },
                          child: Container(
                            child: Image.asset('assets/ic_tree.png'),
                          ),
                        ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
