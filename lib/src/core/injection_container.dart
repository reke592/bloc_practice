import 'package:ale/src/features/recipe/data/datasources/implementations/recipe_memory_data_source.dart';
import 'package:ale/src/features/recipe/data/datasources/recipe_data_source.dart';
import 'package:ale/src/features/recipe/data/repositories/food_recipe_repository_implementation.dart';
import 'package:ale/src/features/recipe/domain/repositories/food_recipe_repository.dart';
import 'package:ale/src/features/recipe/domain/usecases/delete_cooking_step.dart';
import 'package:ale/src/features/recipe/domain/usecases/delete_recepies.dart';
import 'package:ale/src/features/recipe/domain/usecases/get_all_recipes.dart';
import 'package:ale/src/features/recipe/domain/usecases/save_cooking_step.dart';
import 'package:ale/src/features/recipe/domain/usecases/save_recipe.dart';
import 'package:ale/src/features/recipe/presentation/bloc/edit_cooking_step_bloc.dart';
import 'package:ale/src/features/recipe/presentation/bloc/recipe_list_bloc.dart';
import 'package:ale/src/features/recipe/presentation/bloc/recipe_view_bloc.dart';
import 'package:get_it/get_it.dart';

final ic = GetIt.I;

/// initialize standard use cases
void initStandardUsecases() {
  ic
    ..registerFactory(() => RecipeListBloc(
          repo: ic(),
          getAllRecipes: ic(),
          saveRecipe: ic(),
          deleteRecepies: ic(),
        ))
    ..registerFactory(() => RecipeViewBloc(
          repo: ic(),
          saveRecipe: ic(),
        ))
    ..registerFactory(() => EditCookingStepBloc(
          repo: ic(),
          saveCookingStep: ic(),
          deleteCookingStep: ic(),
        ))
    ..registerLazySingleton(() => DeleteCookingStep(ic()))
    ..registerLazySingleton(() => DeleteRecepies(ic()))
    ..registerLazySingleton(() => GetAllRecipes(ic()))
    ..registerLazySingleton(() => SaveCookingStep(ic()))
    ..registerLazySingleton(() => SaveRecipe(ic()))
    ..registerLazySingleton<FoodRecipeRepository>(
        () => FoodRecipeRepositoryImplementation(ic()))
    ..registerLazySingleton<RecipeDataSource>(() => RecipeMemoryDataSource());
}
