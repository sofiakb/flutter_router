import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../tools/utils.dart';
import 'link.dart';

class Rodeo {
  final BuildContext context;
  final GoRouter? router;

  Rodeo({required this.context, this.router});

  Future<void> push(String routeName,
      {Map<String, Link>? routes, Object? extra}) async {
    final goRouter = router ?? GoRouter.of(context);

    // Check for a route guard
    if (routes != null) {
      final Link? link = getRouteFromName(routeName, routes);
      if (link != null &&
          link.guard != null &&
          !(await link.guard!.handle(context))) {
        return; // Guard blocked navigation
      }
    }

    goRouter.go(routeName, extra: extra);
  }

  void pop() {
    final goRouter = router ?? GoRouter.of(context);
    goRouter.pop();
  }
}
