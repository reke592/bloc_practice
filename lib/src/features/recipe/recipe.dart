import 'package:ale/src/core/injection_container.dart';
import 'package:ale/src/features/recipe/presentation/bloc/edit_cooking_step_bloc.dart';
import 'package:ale/src/features/recipe/presentation/bloc/recipe_list_bloc.dart';
import 'package:ale/src/features/recipe/presentation/bloc/recipe_view_bloc.dart';
import 'package:ale/src/features/recipe/presentation/edit_cooking_step/edit_cooking_step_screen.dart';
import 'package:ale/src/features/recipe/presentation/recipe_list/recipe_list_screen.dart';
import 'package:ale/src/features/recipe/presentation/recipe_view/recipe_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

ShellRoute recipeRoutes(
  GlobalKey<NavigatorState> rootNavigatorKey, {
  String root = '/recipe',
}) {
  final navigatorKey = GlobalKey<NavigatorState>();
  return ShellRoute(
    parentNavigatorKey: rootNavigatorKey,
    navigatorKey: navigatorKey,
    routes: [
      GoRoute(
        path: root,
        name: 'list Recipe',
        builder: (context, state) => const RecipeListScreen(),
      ),
      GoRoute(
        path: '$root/view',
        name: 'view Recipe',
        redirect: (context, state) {
          return state.extra is SetRecipeViewModel ? null : root;
        },
        builder: (context, state) => BlocProvider(
          create: (context) =>
              inject<RecipeViewBloc>()..add(state.extra! as SetRecipeViewModel),
          child: const RecipeViewScreen(),
        ),
      ),
      GoRoute(
        path: '$root/view/step',
        name: 'edit Cooking Step',
        redirect: (context, state) {
          return state.extra is SetEditCookingStepViewModel ? null : root;
        },
        builder: (context, state) {
          return BlocProvider(
            create: (context) => inject<EditCookingStepBloc>()
              ..add(state.extra! as SetEditCookingStepViewModel),
            child: const EditCookingStepScreen(),
          );
        },
      ),
    ],
    builder: (context, state, child) => MultiProvider(
      providers: [
        BlocProvider(
          create: (context) {
            return inject<RecipeListBloc>()..add(const LoadFoodRecipes());
          },
        ),
      ],
      child: child,
    ),
  );
}
