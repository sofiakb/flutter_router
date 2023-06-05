import '../core/link.dart';

Link? getRouteFromName(String routeName, Map<String, Link> routes) {
  String routeKey = ('/$routeName').replaceAll(r'//', r'/');
  return routes.containsKey(routeKey) ? routes[routeKey] : null;
}