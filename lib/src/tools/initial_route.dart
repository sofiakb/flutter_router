import '../core/link.dart';

String initialRoute(List<Link> routes) => routes
    .firstWhere((element) => element.initial == true,
        orElse: () => routes.first)
    .path;
