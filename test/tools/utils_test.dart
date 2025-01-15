import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sofiakb_router/sofiakb_router.dart';

void main() {
  group('pathToName', () {
    test('should convert path to dot-separated name', () {
      expect(pathToName('home/dashboard'), 'home.dashboard');
    });

    test('should handle empty path and return "home"', () {
      expect(pathToName(''), 'home');
    });

    test('should normalize paths with redundant slashes', () {
      expect(pathToName('home//dashboard'), 'home.dashboard');
    });
  });

  group('hasRoute', () {
    test('should return true if path matches', () {
      final route = Link.goRouteGenerator(path: '/home', name: 'home');
      expect(hasRoute(route: route, path: '/home'), isTrue);
    });

    test('should return false if path does not match', () {
      final route = Link.goRouteGenerator(path: '/home', name: 'home');
      expect(hasRoute(route: route, path: '/dashboard'), isFalse);
    });

    test('should return true if name matches', () {
      final route = Link.goRouteGenerator(path: '/home', name: 'dashboard');
      expect(hasRoute(route: route, name: 'dashboard'), isTrue);
    });

    test('should return false if neither path nor name matches', () {
      final route = Link.goRouteGenerator(path: '/home', name: 'dashboard');
      expect(
          hasRoute(route: route, path: '/settings', name: 'settings'), isFalse);
    });
  });

  group('findLink', () {
    test('should find the matching link by path', () {
      final links = [
        Link(
          title: 'Home',
          goRoute: Link.goRouteGenerator(path: '/home', name: 'home'),
          links: [],
          initial: false,
          screen: () => Placeholder(),
        ),
        Link(
          title: 'Dashboard',
          goRoute: Link.goRouteGenerator(path: '/dashboard', name: 'Dashboard'),
          links: [],
          initial: false,
          screen: () => Placeholder(),
        ),
      ];

      final result = findLink(links: links, path: '/dashboard');
      expect(result?.title, 'Dashboard');
    });

    test('should find the matching link by name', () {
      final links = [
        Link(
          title: 'Home',
          goRoute: Link.goRouteGenerator(path: '/home', name: 'home'),
          links: [],
          initial: false,
          screen: () => Placeholder(),
        ),
        Link(
          title: 'Dashboard',
          goRoute: Link.goRouteGenerator(path: '/dashboard', name: 'dashboard'),
          links: [],
          initial: false,
          screen: () => Placeholder(),
        ),
      ];

      final result = findLink(links: links, name: 'dashboard');
      expect(result?.title, 'Dashboard');
    });

    test('should find a nested link by path', () {
      final links = [
        Link(
          title: 'Home',
          goRoute: Link.goRouteGenerator(path: '/home', name: 'home'),
          links: [
            Link(
              title: 'Settings',
              goRoute: Link.goRouteGenerator(
                  path: '/home/settings', name: 'Settings'),
              links: [],
              initial: false,
              screen: () => Placeholder(),
            ),
          ],
          initial: false,
          screen: () => Placeholder(),
        ),
      ];

      final result = findLink(links: links, path: '/home/settings');
      expect(result?.title, 'Settings');
    });

    test('should return null if no matching link is found', () {
      final links = [
        Link(
          title: 'Home',
          goRoute: Link.goRouteGenerator(path: '/home', name: 'home'),
          links: [],
          initial: false,
          screen: () => Placeholder(),
        ),
      ];

      final result = findLink(links: links, path: '/dashboard');
      expect(result, isNull);
    });

    test('should return null for an empty list of links', () {
      final links = <Link>[];

      final result = findLink(links: links, path: '/home');
      expect(result, isNull);
    });
  });
}
