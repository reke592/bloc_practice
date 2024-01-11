import 'package:ale/src/core/typedefs.dart';
import 'package:ale/src/features/recipe/data/models/food_recipe_model.dart';
import 'package:ale/src/features/recipe/domain/entities/food_recipe.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const model = FoodRecipeModel(name: 'test', serving: 1);

  test('model should extends to [FoodRecipe] entity', () {
    expect(model, isA<FoodRecipe>());
  });

  test('copyWith returns a [FoodRecipeModel] with updated data', () {
    final actual = model.copyWith(description: 'modified');
    expect(actual.description, equals('modified'));
    expect(actual, isA<FoodRecipeModel>());
  });

  test('toMap returns [DataMap]', () {
    final actual = model.toMap();
    expect(actual, isA<DataMap>());
  });

  test('toJson returns a [String]', () {
    final actual = model.toJson();
    expect(actual, isA<String>());
  });

  test('fromMap returns a [FoodRecipeModel]', () {
    final actual = FoodRecipeModel.fromMap(model.toMap());
    expect(actual, isA<FoodRecipeModel>());
    expect(actual, equals(model));
  });

  test('fromJson returns a [FoodRecipeModel]', () {
    final actual = FoodRecipeModel.fromJson(model.toJson());
    expect(actual, isA<FoodRecipeModel>());
    expect(actual, equals(model));
  });
}
