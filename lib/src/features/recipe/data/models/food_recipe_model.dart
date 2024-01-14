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
    required super.name,
    required super.serving,
    super.id,
    super.steps = const [],
    super.description = '',
  });

  const FoodRecipeModel.empty()
      : this(
          id: null,
          name: 'name',
          serving: 1,
          description: 'description',
          steps: const [],
        );

  factory FoodRecipeModel.fromJson(String source) =>
      FoodRecipeModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  factory FoodRecipeModel.fromMap(DataMap json) => FoodRecipeModel(
        id: json['id'] as int?,
        name: json['name'] as String,
        serving: json['serving'] as int,
        description: json['description'] as String,
        steps: List<DataMap>.from(json['steps'] as List)
            .map(CookingStepModel.fromMap)
            .toList(),
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
