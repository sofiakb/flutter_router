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

  final void Function(
    BuildContext context,
    String name, {
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

  void to(
    BuildContext context, {
    Map<String, String> pathParameters = const {},
    Map<String, String> queryParameters = const {},
    Object? extra,
  }) {
    final name = goRoute.name ?? pathToName(goRoute.path);
    if (onNavigate != null) {
      onNavigate!(context, name,
          pathParameters: pathParameters,
          queryParameters: queryParameters,
          extra: extra);
      return;
    }
    return context.goNamed(name,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra);
  }

  Future toPush(
    BuildContext context, {
    Map<String, String> pathParameters = const {},
    Map<String, String> queryParameters = const {},
    Object? extra,
  }) {
    final name = goRoute.name ?? pathToName(goRoute.path);
    if (onNavigate != null) {
      onNavigate!(context, name,
          pathParameters: pathParameters,
          queryParameters: queryParameters,
          extra: extra);
      return Future.value();
    }
    return context.pushNamed(name,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra);
  }

  GoRoute toGoRoute() => GoRoute(
        path: goRoute.path,
        name: goRoute.name ?? pathToName(goRoute.path),

        builder: bottomNavigation
            ? null
            : (goRoute.builder ?? (context, state) => screen()),

        pageBuilder: bottomNavigation
            ? (context, state) => NoTransitionPage(child: screen())
            : (goRoute.pageBuilder != defaultGoRoutePageBuilder
                ? goRoute.pageBuilder
                : null),

        parentNavigatorKey: goRoute.parentNavigatorKey,
        redirect: goRoute.redirect,
        onExit: goRoute.onExit,
        routes: links.map((link) => link.toGoRoute()).toList(),
      );

  static GoRoute goRouteGenerator({
    required String path,
    required String name,
    GoRouterWidgetBuilder? builder,
    GoRouterPageBuilder? pageBuilder,
    GlobalKey<NavigatorState>? parentNavigatorKey,
    GoRouterRedirect? redirect,
    ExitCallback? onExit,
    List<GoRoute> routes = const [],
  }) =>
      GoRoute(
          name: name,
          path: path,
          builder: builder,
          pageBuilder: builder == null && pageBuilder == null
              ? defaultGoRoutePageBuilder
              : pageBuilder,
          // builder: builder == null && pageBuilder == null
          //     ? defaultGoRouteBuilder
          //     : builder,
          // pageBuilder: pageBuilder,
          parentNavigatorKey: parentNavigatorKey,
          redirect: redirect,
          onExit: onExit,
          routes: routes);

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

  static GoRouterWidgetBuilder get defaultGoRouteBuilder =>
      _defaultGoRouteBuilder;

  static GoRouterPageBuilder get defaultGoRoutePageBuilder =>
      _defaultGoRoutePageBuilder;
}
