import 'package:flutter/material.dart';

import 'route_guard.dart';

class Link {
  late IconData? icon;
  late IconData? activeIcon;
  late String title;
  late String path;
  late Widget widget;
  late Widget? view;
  bool initial;
  bool desktopOnly;
  bool bottomNavigation;
  RouteGuard? guard;

  Link({
    this.icon,
    this.activeIcon,
    required this.title,
    required this.path,
    required this.widget,
    this.view,
    this.initial = false,
    this.desktopOnly = false,
    this.bottomNavigation = false,
    this.guard
  });

  void to(BuildContext context) => Navigator.pushNamed(context, path);
}
