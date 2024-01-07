import 'package:ale/src/features/recipe/data/models/cooking_step_model.dart';
import 'package:ale/src/features/recipe/data/models/food_recipe_model.dart';
import 'package:ale/src/features/recipe/data/models/ingredient_model.dart';

abstract class RecipeDataSource {
  Future<List<FoodRecipeModel>> allRecipes();
  Future<FoodRecipeModel> saveRecipe({
    required int? id,
    required int serving,
    required String name,
    required String description,
    required List<CookingStepModel> steps,
  });
  Future<CookingStepModel> saveCookingStep({
    required int recipeId,
    required int number,
    required Duration duration,
    required List<IngredientModel> ingredients,
    required String instructions,
    required bool active,
  });
  Future<void> deleteStep({
    required int recipeId,
    required int number,
    required bool permanent,
  });
  Future<void> delete(List<int> ids);
}
