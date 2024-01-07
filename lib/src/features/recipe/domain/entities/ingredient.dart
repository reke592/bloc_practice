part of 'food_recipe.dart';

class Ingredient {
  final String name;
  final double amount;
  final String unit;

  const Ingredient({
    required this.name,
    required this.amount,
    required this.unit,
  });

  const Ingredient.empty()
      : this(
          amount: 0,
          name: 'name',
          unit: 'unit',
        );
}
