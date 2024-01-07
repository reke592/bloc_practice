import 'package:ale/src/features/recipe/data/datasources/implementations/recipe_memory_data_source.dart';
import 'package:ale/src/features/recipe/data/repositories/food_recipe_repository_implementation.dart';
import 'package:ale/src/features/recipe/domain/repositories/food_recipe_repository.dart';
import 'package:ale/src/features/recipe/domain/usecases/delete_cooking_step.dart';
import 'package:ale/src/features/recipe/domain/usecases/delete_recepies.dart';
import 'package:ale/src/features/recipe/domain/usecases/get_all_recipes.dart';
import 'package:ale/src/features/recipe/domain/usecases/save_cooking_step.dart';
import 'package:ale/src/features/recipe/domain/usecases/save_recipe.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.I;

/// initialize standard use cases
void initStandardUsecases() {
  final repo = FoodRecipeRepositoryImplementation(RecipeMemoryDataSource());
  locator
    ..registerLazySingleton<FoodRecipeRepository>(() => repo)
    ..registerFactory(() => DeleteCookingStep(repo))
    ..registerFactory(() => DeleteRecepies(repo))
    ..registerFactory(() => GetAllRecipes(repo))
    ..registerFactory(() => SaveCookingStep(repo))
    ..registerFactory(() => SaveRecipe(repo));
}
