import 'package:ale/src/core/typedefs.dart';
import 'package:ale/src/features/recipe/data/models/ingredient_model.dart';
import 'package:ale/src/features/recipe/domain/entities/food_recipe.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const model = IngredientModel.empty();

  test('model should extends to [Ingredient] entity', () {
    expect(model, isA<Ingredient>());
  });

  test('copyWith returns a [IngredientModel] with updated data', () {
    final actual = model.copyWith(unit: 'modified');
    expect(actual.unit, equals('modified'));
    expect(actual, isA<IngredientModel>());
  });

  test('toMap returns [DataMap]', () {
    final actual = model.toMap();
    expect(actual, isA<DataMap>());
  });

  test('toJson returns a [String]', () {
    final actual = model.toJson();
    expect(actual, isA<String>());
  });

  test('fromMap returns a [IngredientModel]', () {
    final actual = IngredientModel.fromMap(model.toMap());
    expect(actual, isA<IngredientModel>());
    expect(actual, equals(model));
  });

  test('fromJson returns a [IngredientModel]', () {
    final actual = IngredientModel.fromJson(model.toJson());
    expect(actual, isA<IngredientModel>());
    expect(actual, equals(model));
  });
}
