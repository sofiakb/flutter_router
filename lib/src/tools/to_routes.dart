import 'package:flutter/material.dart';

import '../core/link.dart';

Map<String, Widget Function(BuildContext context)> toRoutes(
    List<Link> routes) =>
    Map.fromIterable(
        routes/*.where((element) => !element.bottomNavigation)*/, key: (e) => e.path, value: (e) => (context) => e.widget(context));
// routes.map((key, value) => MapEntry(key, (context) => value.widget));
