import 'package:flutter/material.dart';


class OpacityButton extends StatefulWidget {
  final onTap;
  final Widget child;

  const OpacityButton({Key? key, required this.onTap, required this.child}) : super(key: key);

  @override
  _OpacityButtonState createState() => _OpacityButtonState();
}

class _OpacityButtonState extends State<OpacityButton> {
  bool enable = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        widget.onTap();
      },
      onTapDown: (a){
        setState(() {
          enable=true;
        });
      },
      onTapUp: (a){
        setState(() {
          enable=false;
        });
      },
      onTapCancel: (){
        setState(() {
          enable=false;
        });
      },
      child: Opacity(
          opacity: enable?0.5:1,
          child: widget.child
      ),
    );
  }
}