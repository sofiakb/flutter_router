import 'package:flutter/material.dart';
import 'package:sofiakb_router/tools/utils.dart';

import 'link.dart';

class Rodeo {
  final BuildContext? context;
  final GlobalKey<NavigatorState>? navigatorKey;

  Rodeo({this.context, this.navigatorKey});

  // static final Rodeo _instance = Rodeo._internal();
  //
  // factory Rodeo() {
  //   return _instance;
  // }
  //
  // Rodeo._internal({this.context, this.navigatorKey}) {}

  static Rodeo of(BuildContext context) => Rodeo(context: context);

  static Rodeo key(GlobalKey<NavigatorState> navigatorKey) =>
      Rodeo(navigatorKey: navigatorKey);

  push(String routeName, {Map<String, Link>? routes, dynamic arguments}) async {
    if (routes != null) {
      Link? link = getRouteFromName(routeName, routes);

      if (link != null &&
          link.guard != null &&
          await link.guard!.handle(context) == false) {
        return false;
      }
    }

    return context != null
        ? Navigator.of(context!).pushNamed(routeName, arguments: arguments)
        : navigatorKey!.currentState?.pushNamed(routeName, arguments: arguments);
  }

  pop({Map<String, Link>? routes}) async {
    return context != null
        ? Navigator.of(context!).pop()
        : navigatorKey!.currentState?.pop();
  }
}
