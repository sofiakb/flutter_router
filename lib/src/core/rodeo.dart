import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sofiakb_router/sofiakb_router.dart';

import '../tools/utils.dart';

class Rodeo {
  final BuildContext? context;
  final GlobalKey<NavigatorState>? navigatorKey;

  Rodeo({this.context, this.navigatorKey});

  static Rodeo of(BuildContext context) => Rodeo(context: context);

  static Rodeo key(GlobalKey<NavigatorState> navigatorKey) =>
      Rodeo(navigatorKey: navigatorKey);

  Future push(String routeName,
      {Map<String, Link>? routes,
      dynamic arguments,
      Map<String, String> pathParameters = const <String, String>{},
      Map<String, dynamic> queryParameters = const <String, dynamic>{}}) async {
    if (routes != null) {
      Link? link = getRouteFromName(routeName, routes);

      if (link != null &&
          link.guard != null &&
          await link.guard!.handle(context) == false) {
        return false;
      }
    }

    return (context != null
        ? context!.pushNamed(routeName,
            pathParameters: pathParameters,
            queryParameters: queryParameters,
            extra: {'arguments': arguments})
        : routes != null
            ? await GoRouter(
                    routes: toRouterRoutes(routes.values.toList(),
                        navigatorKey: navigatorKey))
                .pushNamed(routeName,
                    pathParameters: pathParameters,
                    queryParameters: queryParameters,
                    extra: {'arguments': arguments})
            : null);
  }

  Future pop({Map<String, Link>? routes}) async {
    if (context != null) {
      if (GoRouter.maybeOf(context!) != null) {
        return GoRouter.of(context!).pop();
      }
    }
    return routes != null
        ? createRouter(routes.values.toList()).pop()
        : navigatorKey?.currentState?.pop();
  }
}
