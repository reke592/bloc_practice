import 'package:ale/src/features/recipe/recipe.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter({this.initialLocation = '/'});
  final String initialLocation;
  final rootNavigatorKey = GlobalKey<NavigatorState>();

  late final config = GoRouter(
    initialLocation: initialLocation,
    navigatorKey: rootNavigatorKey,
    routes: [
      recipeRoutes(rootNavigatorKey),
    ],
  );
}
