import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class Rodeo {
  BuildContext? context;
  GlobalKey<NavigatorState>? navigatorKey;
  GoRouter? router;

  static final Rodeo instance = Rodeo._internal();

  factory Rodeo(GoRouter router, BuildContext context,
      GlobalKey<NavigatorState>? navigatorKey) {
    instance.router = router;
    instance.context = context;
    instance.navigatorKey = navigatorKey;
    return instance;
  }

  Rodeo._internal();

  static initialize(
          {required BuildContext context,
          required GoRouter router,
          required GlobalKey<NavigatorState>? navigatorKey}) =>
      Rodeo(router, context, navigatorKey);

  Future push(
    String routeName, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) async {
    return context != null
        ? context!.pushNamed(
            routeName,
            pathParameters: pathParameters,
            queryParameters: pathParameters,
            extra: extra,
          )
        : router!.pushNamed(
            routeName,
            pathParameters: pathParameters,
            queryParameters: pathParameters,
            extra: extra,
          );
  }

  Future go(
    String routeName, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) async {
    return context != null
        ? context!.goNamed(
            routeName,
            pathParameters: pathParameters,
            queryParameters: pathParameters,
            extra: extra,
          )
        : router!.goNamed(
            routeName,
            pathParameters: pathParameters,
            queryParameters: pathParameters,
            extra: extra,
          );
  }

  Future pop() async {
    return context != null ? context!.pop() : router!.pop();
  }
}
