import 'package:ale/src/core/typedefs.dart';
import 'package:ale/src/features/recipe/data/models/cooking_step_model.dart';
import 'package:ale/src/features/recipe/domain/entities/food_recipe.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const model = CookingStepModel(number: 1);

  test('model should extends to [CookingStep] entity', () {
    expect(model, isA<CookingStep>());
  });

  test('copyWith returns a [CookingStepModel] with updated data', () {
    final actual = model.copyWith(instructions: 'modified');
    expect(actual.instructions, equals('modified'));
    expect(actual, isA<CookingStepModel>());
  });

  test('toMap returns [DataMap]', () {
    final actual = model.toMap();
    expect(actual, isA<DataMap>());
  });

  test('toJson returns a [String]', () {
    final actual = model.toJson();
    expect(actual, isA<String>());
  });

  test('fromMap returns a [CookingStepModel]', () {
    final actual = CookingStepModel.fromMap(model.toMap());
    expect(actual, isA<CookingStepModel>());
    expect(actual, equals(model));
  });

  test('fromJson returns a [CookingStepModel]', () {
    final actual = CookingStepModel.fromJson(model.toJson());
    expect(actual, isA<CookingStepModel>());
    expect(actual, equals(model));
  });
}
