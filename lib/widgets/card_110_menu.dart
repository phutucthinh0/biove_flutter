import 'package:biove/widgets/text_ui.dart';
import 'package:flutter/material.dart';

import 'opacity_button.dart';

class Card110Menu extends StatelessWidget {
  final String title;
  final IconData icon;
  final onTap;
  Card110Menu({required this.title, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return OpacityButton(
      onTap: onTap,
      child: Container(
        width: 110,
        height: 125,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg_card110.png'),
              fit: BoxFit.cover
            ),
            borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Icon(icon,color: Colors.white, size: 30),
            SizedBox(height: 10),
            Container(
              width: 95,
              padding: EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                  color: Colors.white38,
                  borderRadius: BorderRadius.circular(5)
              ),
              child: TextUI(title,textAlign: TextAlign.center, fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16,),
            )
          ],
        ),
      ),
    );
  }
}
