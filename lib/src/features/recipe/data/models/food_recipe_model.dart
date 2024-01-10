import 'dart:convert';

import 'package:ale/src/core/typedefs.dart';
import 'package:ale/src/features/recipe/data/models/cooking_step_model.dart';
import 'package:ale/src/features/recipe/domain/entities/food_recipe.dart';

/// {@template food_recipe}
/// Food Recipe domain aggregate root entity.
/// {@endtemplate}
class FoodRecipeModel extends FoodRecipe {
  /// {@macro food_recipe}
  const FoodRecipeModel({
    super.id,
    required super.name,
    required super.serving,
    super.steps = const [],
    super.description = '',
  });

  factory FoodRecipeModel.fromJson(String source) =>
      FoodRecipeModel.fromMap(jsonDecode(source));

  factory FoodRecipeModel.fromMap(DataMap json) => FoodRecipeModel(
        id: json['id'],
        name: json['name'],
        serving: json['serving'],
        description: json['description'],
        steps: json['steps'].map(CookingStepModel.fromMap).toList(),
      );

  DataMap toMap() => {
        'id': id,
        'name': name,
        'serving': serving,
        'description': description,
        'steps': steps.cast<CookingStepModel>().map((e) => e.toMap()).toList(),
      };

  String toJson() => jsonEncode(toMap());

  FoodRecipeModel copyWith({
    int? id,
    String? name,
    int? serving,
    List<CookingStep>? steps,
    String? description,
  }) =>
      FoodRecipeModel(
        id: id ?? this.id,
        name: name ?? this.name,
        serving: serving ?? this.serving,
        steps: steps ?? this.steps,
        description: description ?? this.description,
      );
}
