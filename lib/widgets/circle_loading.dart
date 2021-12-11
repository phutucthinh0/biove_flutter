import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircleLoading extends StatefulWidget {
  @override
  _CircleLoadingState createState() => _CircleLoadingState();
}

class _CircleLoadingState extends State<CircleLoading> {

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
    );
  }
}
