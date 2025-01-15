import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sofiakb_router/sofiakb_router.dart';

void main() {
  group('initialRoute', () {
    test('should return the path of the route marked as initial', () {
      final routes = [
        Link(
          title: 'home',
          initial: false,
          goRoute: Link.goRouteGenerator(path: '/home', name: 'home'),
          screen: () => const Placeholder(),
        ),
        Link(
          title: 'dashboard',
          initial: true,
          goRoute: Link.goRouteGenerator(path: '/dashboard', name: 'dashboard'),
          screen: () => const Placeholder(),
        ),
        Link(
          title: 'settings',
          initial: false,
          goRoute: Link.goRouteGenerator(path: '/settings', name: 'settings'),
          screen: () => const Placeholder(),
        ),
      ];

      final result = initialRoute(routes);
      expect(result, '/dashboard');
    });

    test('should return the first route path if none are marked as initial',
            () {
          final routes = [
            Link(
              title: 'home',
              initial: false,
              goRoute: Link.goRouteGenerator(path: '/home', name: 'home'),
              screen: () => const Placeholder(),
            ),
            Link(
              title: 'dashboard',
              initial: false,
              goRoute: Link.goRouteGenerator(path: '/dashboard', name: 'dashboard'),
              screen: () => const Placeholder(),
            ),
            Link(
              title: 'settings',
              initial: false,
              goRoute: Link.goRouteGenerator(path: '/settings', name: 'settings'),
              screen: () => const Placeholder(),
            ),
          ];

          final result = initialRoute(routes);
          expect(result, '/home');
        });

    test('should handle an empty list of routes gracefully', () {
      final routes = <Link>[];

      expect(() => initialRoute(routes), throwsStateError);
    });
  });
}
