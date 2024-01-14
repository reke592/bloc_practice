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

final inject = GetIt.I;

/// initialize standard use cases
void initStandardUsecases() {
  inject
    ..registerFactory(
      () => RecipeListBloc(
        repo: inject(),
        getAllRecipes: inject(),
        saveRecipe: inject(),
        deleteRecepies: inject(),
      ),
    )
    ..registerFactory(
      () => RecipeViewBloc(
        repo: inject(),
        saveRecipe: inject(),
      ),
    )
    ..registerFactory(
      () => EditCookingStepBloc(
        saveCookingStep: inject(),
        deleteCookingStep: inject(),
      ),
    )
    ..registerLazySingleton(() => DeleteCookingStep(inject()))
    ..registerLazySingleton(() => DeleteRecepies(inject()))
    ..registerLazySingleton(() => GetAllRecipes(inject()))
    ..registerLazySingleton(() => SaveCookingStep(inject()))
    ..registerLazySingleton(() => SaveRecipe(inject()))
    ..registerLazySingleton<FoodRecipeRepository>(
      () => FoodRecipeRepositoryImplementation(inject()),
    )
    ..registerLazySingleton<RecipeDataSource>(RecipeMemoryDataSource.new);
}
