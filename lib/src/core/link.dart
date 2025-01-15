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

  //late Widget Function(BuildContext) widget;
  //late Widget? Function()? view;

  final void Function(BuildContext context, String path)? onNavigate;

  const Link({
    required this.goRoute,
    required this.screen,
    required this.title,
    this.links = const [],
    this.icon,
    this.activeIcon,

    // required this.widget,
    // this.view,

    this.initial = false,
    this.desktopOnly = false,
    this.bottomNavigation = false,
    this.guard,
    this.onNavigate,
  });

  void to(BuildContext context) => onNavigate != null
      ? onNavigate!(context, goRoute.path)
      : context.pushNamed(goRoute.path);

  static GoRouterWidgetBuilder get defaultGoRouteBuilder =>
      _defaultGoRouteBuilder;

  static GoRouterPageBuilder get defaultGoRoutePageBuilder =>
      _defaultGoRoutePageBuilder;

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

  GoRoute toGoRoute() => GoRoute(
        path: goRoute.path,
        name: goRoute.name ?? pathToName(goRoute.path),
        builder: goRoute.builder ??
            (context, state) {
              if (guard != null) {
                return FutureBuilder(
                    future: guard!.handle(context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }

                      return snapshot.data == true
                          ? screen()
                          : const Placeholder();
                    });
              }
              return screen();
            },
        pageBuilder: goRoute.pageBuilder != defaultGoRoutePageBuilder
            ? goRoute.pageBuilder
            : null,
        // builder:
        //     goRoute.builder != defaultGoRouteBuilder ? goRoute.builder : null,
        // pageBuilder: goRoute.pageBuilder ??
        //     (context, state) => NoTransitionPage(child: screen()),
        parentNavigatorKey: goRoute.parentNavigatorKey,
        redirect: goRoute.redirect,
        onExit: goRoute.onExit,
        routes: links.map((link) => link.toGoRoute()).toList(),
      );
}
