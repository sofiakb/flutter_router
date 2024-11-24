import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'route_guard.dart';

class Link {
  late IconData? icon;
  late IconData? activeIcon;
  late String title;
  late String path;
  late String name;
  late Widget widget;
  late Widget? view;
  bool initial;
  bool desktopOnly;
  bool bottomNavigation;
  RouteGuard? guard;

  void Function(BuildContext context, String path)? onNavigate;

  Link({
    this.icon,
    this.activeIcon,
    required this.title,
    required this.path,
    required this.name,
    required this.widget,
    this.view,
    this.initial = false,
    this.desktopOnly = false,
    this.bottomNavigation = false,
    this.guard,
    this.onNavigate,
  });

  void to(BuildContext context) {
    onNavigate != null
        ? onNavigate!(context, path)
        : context.go(path);
  }
}
