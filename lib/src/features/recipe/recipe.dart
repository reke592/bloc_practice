import 'package:ale/src/features/recipe/data/models/cooking_step_model.dart';
import 'package:ale/src/features/recipe/data/models/food_recipe_model.dart';
import 'package:ale/src/features/recipe/domain/repositories/food_recipe_repository.dart';
import 'package:ale/src/features/recipe/domain/usecases/delete_cooking_step.dart';
import 'package:ale/src/features/recipe/domain/usecases/delete_recepies.dart';
import 'package:ale/src/features/recipe/domain/usecases/get_all_recipes.dart';
import 'package:ale/src/features/recipe/domain/usecases/save_cooking_step.dart';
import 'package:ale/src/features/recipe/domain/usecases/save_recipe.dart';
import 'package:ale/src/features/recipe/presentation/bloc/edit_cooking_step_bloc.dart';
import 'package:ale/src/features/recipe/presentation/bloc/recipe_list_bloc.dart';
import 'package:ale/src/features/recipe/presentation/bloc/recipe_view_bloc.dart';
import 'package:ale/src/features/recipe/presentation/edit_cooking_step/edit_cooking_step_screen.dart';
import 'package:ale/src/features/recipe/presentation/recipe_list/recipe_list_screen.dart';
import 'package:ale/src/features/recipe/presentation/recipe_view/recipe_view_screen.dart';
import 'package:ale/src/locator.dart';
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
          create: (context) => RecipeViewBloc(
            repo: locator<FoodRecipeRepository>(),
            data: state.extra as FoodRecipeModel,
            saveRecipe: locator<SaveRecipe>(),
          ),
          child: const RecipeViewScreen(),
        ),
        routes: [
          GoRoute(
            path: 'step',
            name: 'edit Cooking Step',
            redirect: (context, state) =>
                state.extra is! List<dynamic> ? root : null,
            builder: (context, state) {
              final [recipe, step] = (state.extra as List<dynamic>);
              return BlocProvider(
                create: (context) => EditCookingStepBloc(
                  repo: locator<FoodRecipeRepository>(),
                  recipe: recipe as FoodRecipeModel,
                  data: step as CookingStepModel,
                  deleteCookingStep: locator<DeleteCookingStep>(),
                  saveCookingStep: locator<SaveCookingStep>(),
                ),
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
            return RecipeListBloc(
              repo: locator<FoodRecipeRepository>(),
              deleteRecepies: locator<DeleteRecepies>(),
              getAllRecipes: locator<GetAllRecipes>(),
              saveRecipe: locator<SaveRecipe>(),
            )..add(const LoadFoodRecipes());
          },
        ),
      ],
      child: child,
    ),
  );
}
