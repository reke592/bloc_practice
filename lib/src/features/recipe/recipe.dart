import 'package:ale/src/features/recipe/data/models/food_recipe_model.dart';
import 'package:ale/src/features/recipe/presentation/bloc/edit_cooking_step_bloc.dart';
import 'package:ale/src/features/recipe/presentation/bloc/recipe_list_bloc.dart';
import 'package:ale/src/features/recipe/presentation/bloc/recipe_view_bloc.dart';
import 'package:ale/src/features/recipe/presentation/edit_cooking_step/edit_cooking_step_screen.dart';
import 'package:ale/src/features/recipe/presentation/recipe_list/recipe_list_screen.dart';
import 'package:ale/src/features/recipe/presentation/recipe_view/recipe_view_screen.dart';
import 'package:ale/src/core/injection_container.dart';
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
        builder: (context, state) => BlocProvider(
          create: (context) => ic<RecipeViewBloc>()
            ..add(SetRecipeViewModel(state.extra as FoodRecipeModel)),
          child: const RecipeViewScreen(),
        ),
        routes: [
          GoRoute(
            path: 'step',
            name: 'edit Cooking Step',
            redirect: (context, state) =>
                state.extra is! SetEditCookingStepViewModel ? root : null,
            builder: (context, state) {
              return BlocProvider(
                create: (context) => ic<EditCookingStepBloc>()
                  ..add(state.extra as SetEditCookingStepViewModel),
                child: const EditCookingStepScreen(),
              );
            },
          ),
        ],
      ),
    ],
    builder: (context, state, child) => MultiProvider(
      providers: [
        BlocProvider(
          create: (context) {
            return ic<RecipeListBloc>()..add(const LoadFoodRecipes());
          },
        ),
      ],
      child: child,
    ),
  );
}
