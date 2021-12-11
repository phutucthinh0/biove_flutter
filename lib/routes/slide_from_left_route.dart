import 'package:flutter/material.dart';
class SlideFromLeftRoute extends PageRouteBuilder {
  final Widget page;
  final Duration duration;
  SlideFromLeftRoute({required this.page, this.duration=const Duration(milliseconds: 400)})
      : super(
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    opaque: false,
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
  );
}