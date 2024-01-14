import 'dart:convert';

import 'package:ale/src/core/typedefs.dart';
import 'package:ale/src/features/recipe/domain/entities/food_recipe.dart';

class IngredientModel extends Ingredient {
  const IngredientModel({
    required super.name,
    required super.amount,
    required super.unit,
  });

  const IngredientModel.empty()
      : this(
          amount: 0,
          name: 'name',
          unit: 'unit',
        );

  factory IngredientModel.fromJson(String source) =>
      IngredientModel.fromMap(jsonDecode(source) as DataMap);

  factory IngredientModel.fromMap(DataMap json) => IngredientModel(
        name: json['name'] as String,
        amount: json['amount'] as double,
        unit: json['unit'] as String,
      );

  DataMap toMap() => {
        'name': name,
        'amount': amount,
        'unit': unit,
      };

  String toJson() => jsonEncode(toMap());

  @override
  String toString() => '$name $amount $unit';

  IngredientModel copyWith({
    String? name,
    double? amount,
    String? unit,
  }) =>
      IngredientModel(
        name: name ?? this.name,
        amount: amount ?? this.amount,
        unit: unit ?? this.unit,
      );
}
