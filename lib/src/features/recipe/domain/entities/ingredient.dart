part of 'food_recipe.dart';

class Ingredient extends Equatable {
  final String name;
  final double amount;
  final String unit;

  const Ingredient({
    required this.name,
    required this.amount,
    required this.unit,
  });

  @override
  List<Object?> get props => [name, amount, unit];
}
