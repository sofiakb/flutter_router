import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Rodeo {
  Rodeo._internal();

  static final Rodeo instance = Rodeo._internal();

  BuildContext? context;
  GlobalKey<NavigatorState>? navigatorKey;
  late GoRouter router;

  static void initialize({
    required BuildContext context,
    required GoRouter router,
    required GlobalKey<NavigatorState>? navigatorKey,
  }) {
    instance.context = context;
    instance.router = router;
    instance.navigatorKey = navigatorKey;
  }

  GoRouter _r() => router;

  BuildContext _ctx() =>
      context ?? _r().routerDelegate.navigatorKey.currentContext!;

  Future push(
    String routeName, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) {
    final qp = queryParameters.map((k, v) => MapEntry(k, v?.toString()));
    final ctx = context;
    return ctx != null
        ? ctx.pushNamed(routeName,
            pathParameters: pathParameters, queryParameters: qp, extra: extra)
        : _r().pushNamed(routeName,
            pathParameters: pathParameters, queryParameters: qp, extra: extra);
  }

  Future go(
    String routeName, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) {
    final qp = queryParameters.map((k, v) => MapEntry(k, v?.toString()));
    final ctx = context;
    if (ctx != null) {
      ctx.goNamed(routeName,
          pathParameters: pathParameters, queryParameters: qp, extra: extra);
    } else {
      router!.goNamed(routeName,
          pathParameters: pathParameters, queryParameters: qp, extra: extra);
    }
    return Future.value();
  }

  void pop() {
    final ctx = context;
    if (ctx != null) {
      if (Navigator.of(ctx).canPop()) Navigator.of(ctx).pop();
      return;
    }
    _r().pop();
  }
}
