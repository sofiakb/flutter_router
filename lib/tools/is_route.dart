
import 'package:flutter/material.dart';

bool isRoute(BuildContext context, String routePath) =>
    ModalRoute.of(context)
        ?.settings
        .name
        ?.startsWith(('/' + routePath).replaceAll(r'//', r'/')) ??
    false;
