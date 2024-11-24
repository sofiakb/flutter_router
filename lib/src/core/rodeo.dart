import 'dart:developer';

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
      {Map<String, Link>? routes, dynamic arguments}) async {
    if (routes != null) {
      Link? link = getRouteFromName(routeName, routes);
      log("helloooo");

      if (link != null &&
          link.guard != null &&
          await link.guard!.handle(context) == false) {
        return false;
      }
    }

    return context != null
        ? context!.go(routeName, extra: {'arguments': arguments})
        : routes != null
            ? await GoRouter(routes: toRouterRoutes(routes.values.toList()))
                .push(routeName, extra: {'arguments': arguments})
            : null;
  }

  Future pop({Map<String, Link>? routes}) async {
    if (context != null) {
      // Vérifie si le widget est encore dans l'arbre de widgets
      if (GoRouter.maybeOf(context!) != null) {
        return GoRouter.of(context!).pop();
      }
      throw FlutterError('Le contexte n’est plus valide pour appeler pop.');
    } else {
      return navigatorKey?.currentState?.pop();
    }
  }
}
