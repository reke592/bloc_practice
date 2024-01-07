import 'package:ale/src/core/domain_events.dart';
import 'package:ale/src/core/typedefs.dart';
import 'package:ale/src/features/recipe/domain/entities/food_recipe.dart';
import 'package:ale/src/features/recipe/domain/recipe_domain_event.dart';

abstract class FoodRecipeRepository implements DomainEvents<RecipeDomainEvent> {
  ResultFuture<List<FoodRecipe>> allRecipes();
  ResultFuture<FoodRecipe> saveRecipe({
    required int? id,
    required int serving,
    required String name,
    required String description,
    required List<CookingStep> steps,
  });
  ResultFuture<CookingStep> saveCookingStep({
    required int recipeId,
    required int number,
    required Duration duration,
    required List<Ingredient> ingredients,
    required String instructions,
    required bool active,
  });
  ResultVoid deleteStep({
    required int recipeId,
    required int number,
    required bool permanent,
  });
  ResultVoid delete(List<int> ids);
}
