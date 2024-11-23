import 'package:flutter/material.dart';

import '../core/link.dart';

Map<String, Widget Function(BuildContext context)> toRoutes(
        List<Link> routes) =>
    Map.fromIterable(routes /*.where((element) => !element.bottomNavigation)*/,
        key: (e) => e.path, value: (e) => (context) => e.widget);
// routes.map((key, value) => MapEntry(key, (context) => value.widget));

// GoRouter createRouter(List<Link> routes) {
//   return GoRouter(
//     routes: [
//       for (var link in routes)
//         GoRoute(
//           path: link.path,
//           builder: (context, state) => link.widget,
//           redirect: (context, state) async {
//             if (link.guard != null) {
//               final isAllowed = await link.guard!.handle(context);
//               return isAllowed
//                   ? null
//                   : '/login'; // Redirect to login if not allowed
//             }
//             return null;
//           },
//         ),
//     ],
//   );
// }
