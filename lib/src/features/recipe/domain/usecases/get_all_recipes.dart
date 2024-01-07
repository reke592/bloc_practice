import 'package:ale/src/core/typedefs.dart';
import 'package:ale/src/core/usecase.dart';
import 'package:ale/src/features/recipe/domain/entities/food_recipe.dart';
import 'package:ale/src/features/recipe/domain/repositories/food_recipe_repository.dart';

class GetAllRecipes extends UsecaseWithoutParam<List<FoodRecipe>> {
  const GetAllRecipes(this._repo);

  final FoodRecipeRepository _repo;

  @override
  ResultFuture<List<FoodRecipe>> call() {
    return _repo.allRecipes();
  }
}
