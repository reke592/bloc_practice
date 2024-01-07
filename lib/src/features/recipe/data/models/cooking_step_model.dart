import 'dart:convert';

import 'package:ale/src/core/typedefs.dart';
import 'package:ale/src/features/recipe/data/models/ingredient_model.dart';
import 'package:ale/src/features/recipe/domain/entities/food_recipe.dart';

Duration _durationFromString(String value) {
  final [hours, minutes, seconds] = value.split(':').map(int.parse).toList();
  return Duration(hours: hours, minutes: minutes, seconds: seconds);
}

class CookingStepModel extends CookingStep {
  const CookingStepModel({
    required super.number,
    super.duration = const Duration(),
    super.ingredients = const [],
    super.instructions = '',
    super.active = true,
  });

  factory CookingStepModel.fromJson(String source) =>
      CookingStepModel.fromMap(jsonDecode(source));

  factory CookingStepModel.fromMap(DataMap json) => CookingStepModel(
        number: json['number'],
        duration: _durationFromString(json['duration']),
        active: json['active'] == 1,
        ingredients: json['ingredients'].map(IngredientModel.fromMap).toList(),
        instructions: json['instruction'],
      );

  DataMap toMap() => {
        'number': number,
        'duration': duration.toString().split('.')[0],
        'active': active ? 1 : 0,
        'ingredients':
            ingredients.cast<IngredientModel>().map((e) => e.toMap()).toList(),
        'instructions': instructions,
      };

  String toJson() => jsonEncode(toMap());

  CookingStepModel copyWith({
    int? number,
    Duration? duration,
    String? instructions,
    List<IngredientModel>? ingredients,
    bool? active,
  }) =>
      CookingStepModel(
        number: number ?? this.number,
        duration: duration ?? this.duration,
        ingredients: ingredients ?? this.ingredients,
        instructions: instructions ?? this.instructions,
        active: active ?? this.active,
      );
}
