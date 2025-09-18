import 'package:go_router/go_router.dart';

import '../core/link.dart';

String pathToName(String path) {
  final result = "/$path".split('/').where((char) => char.isNotEmpty).join('.');
  return result.isEmpty ? 'home' : result;
}

bool hasRoute({required GoRoute route, String? path, String? name}) {
  return route.path == path || (name != null && name == route.name);
}

Link? findLink({required List<Link> links, String? path, String? name}) {
  return links
      .map((link) {
        if (hasRoute(route: link.goRoute, path: path, name: name)) {
          return link;
        }
        return findLink(links: link.links, path: path, name: name);
      })
      .nonNulls
      .firstOrNull;
}
