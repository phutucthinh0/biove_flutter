import 'package:flutter/material.dart';

class SlideFromTopRoute extends PageRouteBuilder {
  final Widget page;
  final Duration duration;

  SlideFromTopRoute(
      {required this.page, this.duration = const Duration(milliseconds: 400)})
      : super(
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    opaque: false,
    pageBuilder: (BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,) =>
       page,
    transitionsBuilder: (BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,) =>
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset(0,0),
          ).animate(animation),
          child: child,
        ),
  );
}
