import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/link.dart';

Map<String, Widget Function(BuildContext context)> toRoutes(
        List<Link> routes) =>
    Map.fromIterable(routes /*.where((element) => !element.bottomNavigation)*/,
        key: (e) => e.path, value: (e) => (context) => e.widget);
// routes.map((key, value) => MapEntry(key, (context) => value.widget));

List<GoRoute> toRouterRoutes(List<Link> routes) => routes
    .map((link) => GoRoute(
          path: link.path,
          builder: (context, state) => link.widget,
          redirect: (context, state) async {
            if (link.guard != null) {
              final isAllowed = await link.guard!.handle(context);
              return isAllowed
                  ? link.guard!.handleSuccess()
                  : link.guard!.handleError();
            }
            return null;
          },
        ))
    .toList();

GoRouter createRouter(List<Link> routes) => GoRouter(
      routes: toRouterRoutes(routes),
    );
