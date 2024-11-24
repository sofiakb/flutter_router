import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/link.dart';

Map<String, Widget Function(BuildContext context)> toRoutes(
        List<Link> routes) =>
    Map.fromIterable(routes /*.where((element) => !element.bottomNavigation)*/,
        key: (e) => e.path, value: (e) => (context) => e.widget);
// routes.map((key, value) => MapEntry(key, (context) => value.widget));

List<GoRoute> toRouterRoutes(List<Link> routes,
        {GlobalKey<NavigatorState>? navigatorKey}) =>
    routes
        .map((link) => GoRoute(
              path: link.path,
              name: link.name,
              parentNavigatorKey: navigatorKey,
              builder: (context, state) => link.widget,
              redirect: (context, state) async {
                if (link.guard != null) {
                  return await link.guard!.handle(context)
                      ? null
                      : link.guard!.redirectTo;
                }
                return null;
              },
            ))
        .toList();

GoRouter createRouter(List<Link> routes, {GlobalKey<NavigatorState>? navigatorKey}) => GoRouter(
      routes: toRouterRoutes(routes, navigatorKey: navigatorKey),
    );
