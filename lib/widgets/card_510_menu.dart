import 'dart:ui';

import 'package:biove/widgets/opacity_button.dart';
import 'package:biove/widgets/text_ui.dart';
import 'package:flutter/material.dart';

class Card510Menu extends StatelessWidget {
  final String title;
  final IconData icon;
  final onTap;
  Card510Menu({required this.title, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return OpacityButton(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        margin: EdgeInsets.symmetric(horizontal: 5),
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5)
        ),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.black54),
            SizedBox(width: 20),
            TextUI(title,color: Color(0xff2d4c66), fontWeight: FontWeight.bold),
            Spacer(),
            Icon(Icons.keyboard_arrow_down_outlined, size: 30, color: Color(0xff2d4c66)),
          ],
        ),
      ),
    );
  }
}
