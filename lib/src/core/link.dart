import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../tools/utils.dart';
import 'route_guard.dart';

GoRouterWidgetBuilder _defaultGoRouteBuilder =
    (context, state) => const Placeholder();

GoRouterPageBuilder _defaultGoRoutePageBuilder =
    (context, state) => NoTransitionPage(child: const Placeholder());

class Link {
  final GoRoute goRoute;
  final Widget Function() screen;
  final List<Link> links;

  final bool initial;
  final bool desktopOnly;
  final bool bottomNavigation;
  final RouteGuard? guard;

  final String title;
  final IconData? icon;
  final IconData? activeIcon;

  final void Function(BuildContext context, String name, {
  Map<String, String> pathParameters,
  Map<String, String> queryParameters,
  Object? extra,
  })? onNavigate;

  const Link({
    required this.goRoute,
    required this.screen,
    required this.title,
    this.links = const [],
    this.icon,
    this.activeIcon,
    this.initial = false,
    this.desktopOnly = false,
    this.bottomNavigation = false,
    this.guard,
    this.onNavigate,
  });

  void toGo(BuildContext context, {
    Map<String, String> pathParameters = const {},
    Map<String, String> queryParameters = const {},
    Object? extra,
  }) {
    final name = goRoute.name ?? pathToName(goRoute.path);
    if (onNavigate != null) {
      onNavigate!(context, name, pathParameters: pathParameters, queryParameters: queryParameters, extra: extra);
      return;
    }
    context.goNamed(name, pathParameters: pathParameters, queryParameters: queryParameters, extra: extra);
  }

  void toPush(BuildContext context, {
    Map<String, String> pathParameters = const {},
    Map<String, String> queryParameters = const {},
    Object? extra,
  }) {
    final name = goRoute.name ?? pathToName(goRoute.path);
    if (onNavigate != null) {
      onNavigate!(context, name, pathParameters: pathParameters, queryParameters: queryParameters, extra: extra);
      return;
    }
    context.pushNamed(name, pathParameters: pathParameters, queryParameters: queryParameters, extra: extra);
  }

  GoRoute toGoRoute() => GoRoute(
    path: goRoute.path,
    name: goRoute.name ?? pathToName(goRoute.path),
    builder: goRoute.pageBuilder == null && goRoute.builder == null
        ? (context, state) => _guardedScreen(context)
        : goRoute.builder,
    pageBuilder: goRoute.pageBuilder,
    parentNavigatorKey: goRoute.parentNavigatorKey,
    redirect: goRoute.redirect,
    onExit: goRoute.onExit,
    routes: links.map((l) => l.toGoRoute()).toList(),
  );

  Widget _guardedScreen(BuildContext context) {
    if (guard == null) return screen();

    final future = guard!.handle(context);
    return FutureBuilder<bool>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        final allowed = snapshot.data == true;
        if (allowed) return screen();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // utiliser une route nommée stable
          context.goNamed('login'); // ou une constante partagée
        });
        return const SizedBox.shrink();
      },
    );
  }
}

