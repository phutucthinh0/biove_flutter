import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';

class MapsItem extends StatefulWidget {

  @override
  _MapsItemState createState() => _MapsItemState();
}

class _MapsItemState extends State<MapsItem> {
  @override
  void initState() {
    super.initState();
  }
  final controller = MapController(
    location: LatLng(10.957409, 106.862843),
  );
  final markers = [
    LatLng(10.957409, 106.862843),
    LatLng(10.957311, 106.862867),
    LatLng(10.957047, 106.863135),
  ];
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
  Widget _buildMarkerWidget(Offset pos, Color color) {
    return Positioned(
      left: pos.dx -16,
      top: pos.dy-16,
      width: 40,
      height: 40,
      child: Image.asset('assets/ic_tree.png'),
    );
  }
  @override
  Widget build(BuildContext context) {
    return MapLayoutBuilder(
      controller: controller,
      builder: (context, transformer) {
        final markerPositions =
        markers.map(transformer.fromLatLngToXYCoords).toList();

        final markerWidgets = markerPositions.map(
              (pos) => _buildMarkerWidget(pos, Colors.red),
        );

        final homeLocation =
        transformer.fromLatLngToXYCoords(LatLng(10.957409, 106.862843));

        final homeMarkerWidget =
        _buildMarkerWidget(homeLocation, Colors.black);

        final centerLocation = Offset(
            transformer.constraints.biggest.width / 2,
            transformer.constraints.biggest.height / 2);

        final centerMarkerWidget =
        _buildMarkerWidget(centerLocation, Colors.purple);

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onDoubleTap: _onDoubleTap,
          onScaleStart: _onScaleStart,
          onScaleUpdate: _onScaleUpdate,
          onTapUp: (details) {
            final location =
            transformer.fromXYCoordsToLatLng(details.localPosition);

            final clicked = transformer.fromLatLngToXYCoords(location);

            print('${location.longitude}, ${location.latitude}');
            print('${clicked.dx}, ${clicked.dy}');
            print('${details.localPosition.dx}, ${details.localPosition.dy}');
          },
          child: Listener(
            behavior: HitTestBehavior.opaque,
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
                   final url ="https://tile.openstreetmap.org/${z}/${x}/${y}.png";
                    return Image.network(
                      url,
                      fit: BoxFit.cover,
                    );
                  },
                ),
                // homeMarkerWidget,
                ...markerWidgets,
                // centerMarkerWidget,
              ],
            ),
          ),
        );
      },
    );
  }
}
