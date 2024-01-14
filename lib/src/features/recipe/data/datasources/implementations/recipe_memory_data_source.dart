import 'package:ale/src/features/recipe/data/datasources/recipe_data_source.dart';
import 'package:ale/src/features/recipe/data/models/cooking_step_model.dart';
import 'package:ale/src/features/recipe/data/models/food_recipe_model.dart';
import 'package:ale/src/features/recipe/data/models/ingredient_model.dart';

class RecipeMemoryDataSource extends RecipeDataSource {
  // test data
  final List<FoodRecipeModel> _data = [
    const FoodRecipeModel(
      id: 1,
      name: 'Spicy Garlic Butter Seafood',
      description:
          'This special sauce is so delicious and for the better result use '
          'fresh seafoods. Enjoy it with white rice/fried rice or pineapple rice.',
      serving: 2,
      steps: [
        CookingStepModel(
          number: 1,
          ingredients: [
            IngredientModel(name: 'Black Peppercorns', amount: 2, unit: 'tsp'),
            IngredientModel(name: 'Water', amount: 2, unit: 'l'),
          ],
          instructions: 'Boil water and add black peppercorns',
        ),
        CookingStepModel(
          number: 2,
          duration: Duration(minutes: 2),
          ingredients: [
            IngredientModel(name: 'Shrimp', amount: 200, unit: 'g'),
            IngredientModel(name: 'Calamari', amount: 200, unit: 'g'),
            IngredientModel(name: 'Mussels', amount: 200, unit: 'g'),
            IngredientModel(name: 'Sweet Corn', amount: 2, unit: 'pc'),
          ],
          instructions:
              "Boil all ingredients. For shrimp, boil until it's pink. "
              'It takes about 2 minutes. And continue boil the rest of '
              'ingredients until they are cooked/soft. Strained, set a side.',
        ),
        CookingStepModel(
          number: 3,
          duration: Duration(minutes: 5),
          ingredients: [
            IngredientModel(name: 'Butter', amount: 250, unit: 'g'),
            IngredientModel(
              name: 'Korean chili paste',
              amount: 2,
              unit: 'tbsp',
            ),
            IngredientModel(
              name: 'yellow Thai curry paste',
              amount: 1,
              unit: 'package',
            ),
            IngredientModel(name: 'Chicken stock', amount: 200, unit: 'ml'),
            IngredientModel(name: 'Garlic', amount: 5, unit: 'cloves'),
            IngredientModel(name: 'Olive Oil', amount: 2, unit: 'tbsp'),
            IngredientModel(name: 'Salt', amount: 2, unit: 'tsp'),
            IngredientModel(name: 'Brown Sugar', amount: 3, unit: 'tbsp'),
          ],
          instructions:
              'In a frying pan, first add olive oil and fry the onion and '
              'garlic until it’s fragrance. Next add butter until completely '
              'melted.Add Korean Chili paste, yellow Thai curry paste, '
              'brown sugar, salt and the remaining black peppercorn. '
              'Last add chicken stock. Let it simmer for about 5 minutes. '
              'Turn off the gas.',
        ),
        CookingStepModel(
          number: 4,
          instructions:
              'Add the shrimp, calamari, mussels and corn to the pan. '
              'Mixed with the sauce until it’s combined. '
              'And your spicy garlic butter seafood is ready!',
        ),
      ],
    ),
  ];

  @override
  Future<List<FoodRecipeModel>> allRecipes() async {
    return List.of(_data, growable: false);
  }

  @override
  Future<void> delete(List<int> ids) async {
    if (ids.isNotEmpty) {
      for (final id in ids) {
        _data.removeWhere((element) => element.id == id);
      }
    }
  }

  @override
  Future<void> deleteStep({
    required int recipeId,
    required int number,
    required bool permanent,
  }) async {
    final index = _data.indexWhere((element) => element.id == recipeId);
    FoodRecipeModel updated;
    if (index < 0) throw Exception('recipe record not found');
    if (permanent) {
      updated = _data[index].copyWith(
        steps: List.from(_data[index].steps)
          ..removeWhere((element) => element.number == number),
      );
    } else {
      final stepIndex =
          _data[index].steps.indexWhere((element) => element.number == number);
      if (stepIndex < 0) throw Exception('recipe step not found');
      final updatedSteps = List<CookingStepModel>.from(_data[index].steps);
      updatedSteps[stepIndex] = updatedSteps[stepIndex].copyWith(active: false);
      updated = _data[index].copyWith(
        steps: updatedSteps,
      );
    }
    _data[index] = updated;
  }

  @override
  Future<CookingStepModel> saveCookingStep({
    required int recipeId,
    required int number,
    required Duration duration,
    required List<IngredientModel> ingredients,
    required String instructions,
    required bool active,
  }) async {
    final index = _data.indexWhere((element) => element.id == recipeId);
    if (index == -1) throw Exception('recipe not found');
    var record = _data[index];
    CookingStepModel updatedStep;
    final stepIndex =
        record.steps.indexWhere((element) => element.number == number);
    final updated = List<CookingStepModel>.from(record.steps);
    if (stepIndex == -1) {
      updatedStep = CookingStepModel(
        number: number,
        duration: duration,
        ingredients: ingredients,
        instructions: instructions,
        active: active,
      );
      record = record.copyWith(steps: updated..add(updatedStep));
    } else {
      updatedStep = updated[stepIndex] = updated[stepIndex].copyWith(
        number: number,
        duration: duration,
        ingredients: ingredients.cast<IngredientModel>(),
        instructions: instructions,
        active: active,
      );
      record = record.copyWith(steps: updated);
    }
    _data[index] = record;

    return updatedStep;
  }

  @override
  Future<FoodRecipeModel> saveRecipe({
    required int? id,
    required int serving,
    required String name,
    required String description,
    required List<CookingStepModel> steps,
  }) async {
    final result = FoodRecipeModel(
      id: id ?? _data.length + 1,
      name: name,
      serving: serving,
      steps: steps,
      description: description,
    );
    if (id == null) {
      _data.add(result);
    } else {
      final index = _data.indexWhere((element) => element.id == id);
      _data[index] = _data[index];
    }

    return result;
  }
}
