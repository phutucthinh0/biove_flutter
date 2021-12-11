import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonUI extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final Color textColor;
  TextAlign? textAlign;
  final Color backgroundColor;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Widget? iconLeft;
  final Widget? iconRight;
  final BorderRadius borderRadius;
  Function()? onTap;

  ButtonUI({
    this.width = double.infinity,
    this.height = double.infinity,
    this.text = "",
    this.textColor = Colors.black,
    this.fontSize = 18,
    this.fontWeight = FontWeight.normal,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.all(12),
    this.onTap,
    this.backgroundColor = Colors.transparent,
    this.iconLeft,
    this.iconRight,
    this.borderRadius = BorderRadius.zero,
    this.textAlign
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      child: InkWell(
        focusColor: Colors.white,
        onTap: onTap,
        child: Container(
            margin: margin,
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
            ),
            child: (iconLeft == null && iconRight==null)
                ? Text(text, style: TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: textColor),textAlign: textAlign)
                :(iconRight==null)
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      iconLeft as Widget,
                      SizedBox(width: 15),
                      Text(
                        text,
                        style: TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: textColor),
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        text,
                        style: TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: textColor),
                      ),
                      SizedBox(width: 15),
                      iconRight as Widget,
                    ],
                  ))
      ),
    );
  }
}
